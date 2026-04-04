{
  config,
  inputs,
  lib,
  ...
}:
let
  hosts = lib.filterAttrs (_: host: host.enable) config.repo.hosts;

  channelInputs = channel: {
    nixpkgs =
      if channel == "stable" then
        inputs.nixpkgs-stable
      else
        inputs.nixpkgs;
    homeManager =
      if channel == "stable" then
        inputs.home-manager-stable
      else
        inputs.home-manager;
  };

  defaultHomeDirectory =
    host: user:
    if user.homeDirectory != null then
      user.homeDirectory
    else if host.platform == "darwin" then
      "/Users/${user.username}"
    else
      "/home/${user.username}";

  resolveUser =
    host:
    config.repo.users.${host.user}
    or (throw "Host `${host.hostname}` references unknown user `${host.user}`.");

  resolveFeature =
    host: name:
    let
      feature =
        config.repo.featureRegistry.${name}
        or (throw "Host `${host.hostname}` references unknown feature `${name}`.");
    in
    if builtins.elem host.platform feature.platforms then
      feature
    else
      throw "Feature `${name}` does not support platform `${host.platform}` for host `${host.hostname}`.";

  featureNames =
    host: user:
    lib.unique (host.roles ++ host.features ++ user.features);

  featureModulesFor =
    key: host: user:
    let
      registry =
        if key == "nixosModules" then
          config.flake.modules.nixos or { }
        else if key == "darwinModules" then
          config.flake.modules.darwin or { }
        else
          config.flake.modules.homeManager or { };
      resolveNamedModule =
        name:
        registry.${name}
        or (throw "Lower-level module `${name}` is not registered in flake.modules.${if key == "homeModules" then "homeManager" else lib.removeSuffix "Modules" key}.");
    in
    lib.concatMap (feature: map resolveNamedModule feature.${key}) (map (resolveFeature host) (featureNames host user));

  featureSharedModulesFor =
    host: user:
    lib.concatMap (feature: feature.homeManagerSharedModules) (map (resolveFeature host) (featureNames host user));

  namedModulesFor =
    class: names:
    let
      registry = config.flake.modules.${class} or { };
    in
    map (
      name:
      registry.${name}
      or (throw "Lower-level module `${name}` is not registered in flake.modules.${class}.")
    ) names;

  commonBootstrapModules = host: user: [
    { nixpkgs.hostPlatform = host.system; }
    (
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        nix.package = pkgs.lixPackageSets.stable.lix;
        mySystem.username = lib.mkDefault user.username;
      }
    )
  ];

  mkHomeManagerModule =
    host: user: homeModules:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs; };
        sharedModules = featureSharedModulesFor host user;
        users.${user.username} = {
          imports = homeModules;

          home = {
            username = user.username;
            homeDirectory = defaultHomeDirectory host user;
            stateVersion = host.homeStateVersion;
          };
        };
      };
    };

  mkNixosConfiguration =
    host:
    let
      user = resolveUser host;
      channels = channelInputs host.channel;
      homeModules =
        namedModulesFor "homeManager" user.homeModules
        ++ namedModulesFor "homeManager" host.homeModules
        ++ featureModulesFor "homeModules" host user;
      nixosModules =
        namedModulesFor "nixos" host.nixosModules
        ++ featureModulesFor "nixosModules" host user
        ++ lib.optionals (builtins.elem "disko" host.features) (
          if host.diskoModule == null then
            throw "Host `${host.hostname}` enables `disko` but does not define `diskoModule`."
          else
            [
              inputs.disko.nixosModules.disko
              (builtins.head (namedModulesFor "nixos" [ host.diskoModule ]))
            ]
        );
    in
    channels.nixpkgs.lib.nixosSystem {
      system = host.system;
      specialArgs = { inherit inputs; };
      modules =
        commonBootstrapModules host user
        ++ nixosModules
        ++ lib.optionals (homeModules != [ ]) [
          channels.homeManager.nixosModules.home-manager
          (mkHomeManagerModule host user homeModules)
        ];
    };

  mkDarwinConfiguration =
    host:
    let
      user = resolveUser host;
      channels = channelInputs host.channel;
      pkgs = import channels.nixpkgs {
        system = host.system;
        config.allowUnfree = true;
      };
      homeModules =
        namedModulesFor "homeManager" user.homeModules
        ++ namedModulesFor "homeManager" host.homeModules
        ++ featureModulesFor "homeModules" host user;
      darwinModules =
        namedModulesFor "darwin" host.darwinModules
        ++ featureModulesFor "darwinModules" host user;
    in
    inputs.nix-darwin.lib.darwinSystem {
      system = host.system;
      inherit pkgs;
      specialArgs = { inherit inputs; };
      modules =
        commonBootstrapModules host user
        ++ darwinModules
        ++ lib.optionals (homeModules != [ ]) [
          channels.homeManager.darwinModules.home-manager
          (mkHomeManagerModule host user homeModules)
        ];
    };
in
{
  flake = {
    nixosConfigurations = lib.mapAttrs (_: host: mkNixosConfiguration host) (
      lib.filterAttrs (_: host: host.platform == "nixos") hosts
    );
    darwinConfigurations = lib.mapAttrs (_: host: mkDarwinConfiguration host) (
      lib.filterAttrs (_: host: host.platform == "darwin") hosts
    );
  };
}
