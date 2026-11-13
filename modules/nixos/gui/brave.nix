{
  # Brave reads Chromium policies from /etc/brave/policies/managed;
  # brave-origin reads the same directory (brave-core sets it for all
  # Linux builds). Origin already compiles out rewards/wallet/AI, so
  # those policy keys are omitted.
  environment.etc."brave/policies/managed/default.json".text = builtins.toJSON {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderKeyword = "g";
    DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
    HomepageLocation = "https://www.google.com";
    RestoreOnStartup = 4; # open specific URLs
    RestoreOnStartupURLs = [ "https://www.google.com" ];
    PasswordManagerEnabled = false;
    DefaultNotificationsSetting = 1; # block all site notification requests
  };
}
