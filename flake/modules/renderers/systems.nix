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

  resolveAspect =
    host: name:
    let
      aspect =
        config.repo.aspects.${name}
        or (throw "Host `${host.hostname}` references unknown aspect `${name}`.");
    in
    if builtins.elem host.platform aspect.platforms then
      aspect
    else
      throw "Aspect `${name}` does not support platform `${host.platform}` for host `${host.hostname}`.";

  aspectNames =
    host: user:
    lib.unique (host.aspects ++ user.aspects);

  aspectClosure =
    host:
    names:
    let
      visit =
        name:
        let
          aspect = resolveAspect host name;
        in
        [ name ] ++ lib.concatMap visit aspect.includes;
    in
    lib.unique (lib.concatMap visit names);

  aspectModulesFor =
    key: host: user:
    lib.concatMap (name: (resolveAspect host name).${key}) (aspectClosure host (aspectNames host user));

  aspectSharedModulesFor =
    host: user:
    aspectModulesFor "homeManagerSharedModules" host user;

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
        sharedModules = aspectSharedModulesFor host user;
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
        user.homeModules
        ++ host.homeModules
        ++ aspectModulesFor "homeModules" host user;
      nixosModules = host.nixosModules ++ aspectModulesFor "nixosModules" host user;
      nixosModulesWithDisko =
        nixosModules
        ++ lib.optionals (builtins.elem "disko" host.aspects) (
          if host.diskoModule == null then
            throw "Host `${host.hostname}` includes `disko` but does not define `diskoModule`."
          else
            [
              inputs.disko.nixosModules.disko
              host.diskoModule
            ]
        );
    in
    channels.nixpkgs.lib.nixosSystem {
      system = host.system;
      specialArgs = { inherit inputs; };
      modules =
        commonBootstrapModules host user
        ++ nixosModulesWithDisko
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
        user.homeModules
        ++ host.homeModules
        ++ aspectModulesFor "homeModules" host user;
      darwinModules =
        host.darwinModules
        ++ aspectModulesFor "darwinModules" host user;
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
