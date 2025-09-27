// Compatibility shim to support legacy "chatwoot" globals while we rebrand to "CHATCE".
// This file creates safe aliases so external embeds and existing code continue to work
// while visible strings and asset branding are updated.

(function () {
  if (typeof window === 'undefined') return;

  // Alias core globals used by embeds
  if (!window.$chatce) window.$chatce = window.$chatwoot;
  if (!window.chatceSettings) window.chatceSettings = window.chatwootSettings;
  if (!window.chatcePubsubToken)
    window.chatcePubsubToken = window.chatwootPubsubToken;

  // Alias the mounted widget reference
  if (!window.WOOT_CHATCE) window.WOOT_CHATCE = window.WOOT_WIDGET;

  // Provide iframe id alias used by some embed scripts
  window.CHATWOOT_IFRAME_ID =
    window.CHATWOOT_IFRAME_ID || 'chatwoot_live_chat_widget';
  window.CHATCE_IFRAME_ID =
    window.CHATCE_IFRAME_ID || window.CHATWOOT_IFRAME_ID;

  // Post message prefixes (keep the original as the canonical prefix)
  window.chatwootPostMessagePrefix =
    window.chatwootPostMessagePrefix || 'chatwoot-widget:';
  window.chatcePostMessagePrefix =
    window.chatcePostMessagePrefix || window.chatwootPostMessagePrefix;
})();
