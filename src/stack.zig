const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

pub const STACK_ERROR = error {
    PEEK_ERROR,
};

pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            nextNode: ?*Node = null,
            data: T,

            pub const DataType = T;
        };

        Last: ?*Node = null,
        First: ?*Node = null,
        Size: usize = 0,

        /// Add's a new node into the stack.
        pub fn push(self: *Self, newNode: *Node) void {
            if (self.First == null) self.Last = newNode;
            newNode.nextNode = self.First;
            self.First = newNode;
            self.Size += 1;    
        }

        /// Moves the pointer to the next node the returns the previous one.
        /// Return's null if the current node is null.
        pub fn pop(self: *Self) ?*Node {
            const first = self.First orelse return null;
            self.First = first.nextNode;

            if (self.First == null) {
                self.Last = null;
            }

            self.Size -= 1;
            return first;
        }

        /// Returns the first node. 
        pub fn peekFirst(self: *Self) STACK_ERROR!*Node {
            return self.First orelse STACK_ERROR.PEEK_ERROR;
        }

        /// Returns the last node.
        pub fn peekLast(self: *Self) STACK_ERROR!*Node {
            return self.Last orelse STACK_ERROR.PEEK_ERROR;
        }

        /// Checks if the first node is null.
        pub fn isEmpty(self: *Self) bool {
            return self.First == null;
        }
    };
}

test "Stack testing ground" {
    const Ch_stack = Stack(u8);
    var stack: Ch_stack = .{};

    try testing.expect(stack.isEmpty());
    var node1: Ch_stack.Node = .{ .data = 'a' };
    var node2: Ch_stack.Node = .{ .data = 'b' };
    var node3: Ch_stack.Node = .{ .data = 'c' };
    var node4: Ch_stack.Node = .{ .data = 'd' };

    try testing.expect(stack.Size == 0);
    stack.push(&node1);

    try testing.expect(stack.Size == 1);
    try testing.expect(stack.First != null);

    stack.push(&node2);
    stack.push(&node3);
    stack.push(&node4);

    const first = try stack.peekFirst();
    try testing.expect(first.data == 'd');
    const last = try stack.peekLast();
    try testing.expect(last.data == 'a');

    try testing.expect(stack.Size == 4);
    while (!stack.isEmpty()) {
        const pNode = stack.pop();
        try testing.expect(pNode != null);
    }

    try testing.expect(stack.isEmpty());
    try testing.expectError(STACK_ERROR.PEEK_ERROR, stack.peekFirst());
    try testing.expectError(STACK_ERROR.PEEK_ERROR, stack.peekLast());
}
