const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

pub const QUEUE_ERROR = error{
    PEEK_ERROR,
};

pub fn Queue(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            nextNode: ?*Node = null,
            data: T,

            pub const DataType = T;
        };

        First: ?*Node = null,
        Last: ?*Node = null,
        Size: usize = 0,

        /// Add's a new node into the queue
        pub fn push(self: *Self, newNode: ?*Node) void {
            if (self.isEmpty()) {
                self.First = newNode;
                self.Last = newNode;
            } else {
                self.Last.?.nextNode = newNode;
                self.Last = newNode;
            }
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
        pub fn peekFirst(self: *Self) QUEUE_ERROR!*Node {
            return self.First orelse return QUEUE_ERROR.PEEK_ERROR;
        }

        /// Returns the last node.
        pub fn peekLast(self: *Self) QUEUE_ERROR!*Node {
            return self.Last orelse return QUEUE_ERROR.PEEK_ERROR;
        }
        
        /// Check if the first node is null.
        pub fn isEmpty(self: *Self) bool {
            return self.First == null;
        }
    };
}

test "Queue testing ground" {
    const Ch_queue = Queue(u8);
    var queue: Ch_queue = .{};

    try testing.expect(queue.First == null);
    var node1: Ch_queue.Node = .{ .data = 'a' };
    var node2: Ch_queue.Node = .{ .data = 'b' };
    var node3: Ch_queue.Node = .{ .data = 'c' };
    var node4: Ch_queue.Node = .{ .data = 'd' };

    try testing.expect(queue.Size == 0);
    queue.push(&node1);

    try testing.expect(queue.Size == 1);
    try testing.expect(queue.First != null);
    try testing.expect(queue.First == queue.First);
    const first = try queue.peekFirst(); 
    try testing.expect(first.data == 'a');
    
    queue.push(&node2);
    queue.push(&node3);
    queue.push(&node4);

    const last = try queue.peekLast(); 
    try testing.expect(last.data == 'd');
    try testing.expect(queue.First.?.data == 'a');
    try testing.expect(queue.Last.?.data == 'd');

    try testing.expect(queue.Size == 4);
    while (!queue.isEmpty()) {
        const pNode = queue.pop();
        try testing.expect(pNode != null);
    }

    try testing.expect(queue.isEmpty());
    try testing.expect(queue.Last == queue.First);
    try testing.expectError(QUEUE_ERROR.PEEK_ERROR, queue.peekFirst());
}
