/**
 * Composable for branding-related utilities
 * Provides methods to customize text with installation-specific branding
 */
import { useMapGetter } from 'dashboard/composables/store.js';

export function useBranding() {
  const globalConfig = useMapGetter('globalConfig/get');
  /**
   * Replaces occurrences of the original product name (CHATCE) or its
   * rebranded token (CHATCE) in text with the installation name from global config.
   * This handles different casings to be resilient during an in-progress rebrand.
   * @param {string} text - The text to process
   * @returns {string} - Text with the product name replaced by installation name
   */
  const replaceInstallationName = text => {
    if (!text) return text;

    const installationName = globalConfig.value?.installationName;
    if (!installationName) return text;

    // Only replace the explicit rebrand token CHATCE (case-sensitive).
    // We avoid replacing arbitrary occurrences of the legacy product name to keep
    // existing runtime/embedded identifiers stable during a staged rebrand.
    return text.replace(/CHATCE/g, installationName);
  };

  return {
    replaceInstallationName,
  };
}
