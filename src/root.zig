const stackBuilder = @import("stack.zig");
const queueBuilder = @import("queue.zig");

pub const STACK_ERRORS = stackBuilder.STACK_ERROR;
pub const QUEUE_ERRORS = queueBuilder.QUEUE_ERROR;

/// Create's a stack of the specified type.
pub fn CreateStack(comptime T: type) type {
    return stackBuilder.Stack(T);
}


/// Creates a queue of the specified type.
pub fn CreateQueue(comptime T: type) type {
    return queueBuilder.Queue(T);
}
