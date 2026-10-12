{
  # Brave reads Chromium policies from /etc/brave/policies/managed.
  environment.etc."brave/policies/managed/default.json".text = builtins.toJSON {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderKeyword = "g";
    DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
    HomepageLocation = "https://www.google.com";
    RestoreOnStartup = 4; # open specific URLs
    RestoreOnStartupURLs = [ "https://www.google.com" ];
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveAIChatEnabled = false;
    PasswordManagerEnabled = false;
  };
}
