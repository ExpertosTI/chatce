export const CHATWOOT_ERROR = 'chatwoot:error';
export const CHATWOOT_ON_MESSAGE = 'chatwoot:on-message';
export const CHATWOOT_ON_START_CONVERSATION = 'chatwoot:on-start-conversation';
export const CHATWOOT_POSTBACK = 'chatwoot:postback';
export const CHATWOOT_READY = 'chatwoot:ready';
export const CHATWOOT_OPENED = 'chatwoot:opened';
export const CHATWOOT_CLOSED = 'chatwoot:closed';

// Aliases for rebranding to CHATCE. Consumers can use either set of constants.
export const CHATCE_ERROR = CHATWOOT_ERROR.replace('chatwoot', 'chatce');
export const CHATCE_ON_MESSAGE = CHATWOOT_ON_MESSAGE.replace(
  'chatwoot',
  'chatce'
);
export const CHATCE_ON_START_CONVERSATION =
  CHATWOOT_ON_START_CONVERSATION.replace('chatwoot', 'chatce');
export const CHATCE_POSTBACK = CHATWOOT_POSTBACK.replace('chatwoot', 'chatce');
export const CHATCE_READY = CHATWOOT_READY.replace('chatwoot', 'chatce');
export const CHATCE_OPENED = CHATWOOT_OPENED.replace('chatwoot', 'chatce');
export const CHATCE_CLOSED = CHATWOOT_CLOSED.replace('chatwoot', 'chatce');
