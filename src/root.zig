const real = f32;

const Vector3Error = error{
    InputVectorsAreParallel,
};

pub const Vector3 = struct {
    x: real,
    y: real,
    z: real,

    pub fn zero() Vector3 {
        return Vector3{ .x = 0, .y = 0, .z = 0 };
    }

    pub fn init(x: real, y: real, z: real) Vector3 {
        return Vector3{ .x = x, .y = y, .z = z };
    }

    pub fn inverted(self: Vector3) Vector3 {
        return Vector3{ .x = -self.x, .y = -self.y, .z = -self.z };
    }

    pub fn normalized(self: Vector3) Vector3 {
        const mag = self.magnitude();
        if (mag == 0) {
            return self;
        }

        return self.scale(1.0 / mag);
    }

    pub fn magnitude(self: Vector3) real {
        return @sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
    }

    pub fn magnitudeSquared(self: Vector3) real {
        return self.x * self.x + self.y * self.y + self.z * self.z;
    }

    pub fn scale(self: Vector3, scalar: real) Vector3 {
        return Vector3{ .x = self.x * scalar, .y = self.y * scalar, .z = self.z * scalar };
    }

    pub fn add(self: Vector3, other: Vector3) Vector3 {
        return Vector3{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z };
    }

    pub fn subtract(self: Vector3, other: Vector3) Vector3 {
        return Vector3{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z };
    }

    pub fn addScaled(self: Vector3, other: Vector3, scalar: real) Vector3 {
        return Vector3{
            .x = self.x + other.x * scalar,
            .y = self.y + other.y * scalar,
            .z = self.z + other.z * scalar,
        };
    }

    pub fn componentProduct(self: Vector3, other: Vector3) Vector3 {
        return Vector3{ .x = self.x * other.x, .y = self.y * other.y, .z = self.z * other.z };
    }

    pub fn dot(self: Vector3, other: Vector3) real {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn multiply(self: Vector3, other: Vector3) Vector3 {
        return Vector3{
            .x = self.y * other.z - self.z * other.y,
            .y = self.z * other.x - self.x * other.z,
            .z = self.x * other.y - self.y * other.x,
        };
    }

    pub fn makeOrthonormalBasis(A: Vector3, B: Vector3) !struct { Vector3, Vector3, Vector3 } {
        const a = A.normalized();
        var c = A.multiply(B);

        if (c.magnitudeSquared() == 0) {
            return Vector3Error.InputVectorsAreParallel;
        }

        c = c.normalized();

        const b = c.multiply(a);

        return .{ a, b, c };
    }
};

const std = @import("std");

test "cross product" {
    const a = Vector3.init(2, 0, 0);
    const b = Vector3.init(0, 3, 0);
    try std.testing.expectEqual(Vector3.multiply(a, b), Vector3.init(0, 0, 6));
}

test "make orthonormal basis" {
    const a = Vector3.init(2, 0, 0);
    const b = Vector3.init(0, 3, 0);

    const result = try Vector3.makeOrthonormalBasis(a, b);
    try std.testing.expectEqual(result, .{ Vector3.init(1, 0, 0), Vector3.init(0, 1, 0), Vector3.init(0, 0, 1) });
}
