import { useBranding } from '../useBranding';
import { useMapGetter } from 'dashboard/composables/store.js';

// Mock the store composable
vi.mock('dashboard/composables/store.js', () => ({
  useMapGetter: vi.fn(),
}));

describe('useBranding', () => {
  let mockGlobalConfig;

  beforeEach(() => {
    mockGlobalConfig = {
      value: {
        installationName: 'MyCompany',
      },
    };

    useMapGetter.mockReturnValue(mockGlobalConfig);
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  describe('replaceInstallationName', () => {
    it('should replace "CHATCE" with installation name when both text and installation name are provided', () => {
      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName('Welcome to CHATCE');

      expect(result).toBe('Welcome to MyCompany');
    });

    it('should replace multiple occurrences of "CHATCE"', () => {
      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName(
        'CHATCE is great! Use CHATCE today.'
      );

      expect(result).toBe('MyCompany is great! Use MyCompany today.');
    });

    it('should return original text when installation name is not provided', () => {
      mockGlobalConfig.value = {};

      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName('Welcome to CHATCE');

      expect(result).toBe('Welcome to CHATCE');
    });

    it('should return original text when globalConfig is not available', () => {
      mockGlobalConfig.value = undefined;

      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName('Welcome to CHATCE');

      expect(result).toBe('Welcome to CHATCE');
    });

    it('should return original text when text is empty or null', () => {
      const { replaceInstallationName } = useBranding();

      expect(replaceInstallationName('')).toBe('');
      expect(replaceInstallationName(null)).toBe(null);
      expect(replaceInstallationName(undefined)).toBe(undefined);
    });

    it('should handle text without "CHATCE" gracefully', () => {
      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName('Welcome to our platform');

      expect(result).toBe('Welcome to our platform');
    });

    it('should be case-sensitive for "CHATCE"', () => {
      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName(
        'Welcome to chatwoot and CHATWOOT'
      );

      expect(result).toBe('Welcome to chatwoot and CHATWOOT');
    });

    it('should handle special characters in installation name', () => {
      mockGlobalConfig.value = {
        installationName: 'My-Company & Co.',
      };

      const { replaceInstallationName } = useBranding();
      const result = replaceInstallationName('Welcome to CHATCE');

      expect(result).toBe('Welcome to My-Company & Co.');
    });
  });
});
