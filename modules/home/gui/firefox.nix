{ ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      Homepage = {
        URL = "https://www.google.com";
        StartPage = "homepage";
      };
      DefaultSearchProvider = {
        Name = "Google";
        SearchURL = "https://www.google.com/search?q={searchTerms}";
        SuggestURL = "https://www.google.com/complete/search?client=firefox&q={searchTerms}";
        IsDefault = true;
      };
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      ExtensionSettings."uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
    };
  };
}
