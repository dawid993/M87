
const lightningMessageService = {
    APPLICATION_SCOPE: Symbol('APPLICATION_SCOPE'),
    createMessageChannel: jest.fn(),
    createMessageContext: jest.fn(),
    MessageContext: jest.fn(),
    publish: jest.fn(),
    releaseMessageContext: jest.fn(),
    subscribe: jest.fn(),
    unsubscribe: jest.fn(),
}

export {lightningMessageService};