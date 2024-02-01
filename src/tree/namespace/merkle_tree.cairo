use alexandria_bytes::Bytes;
use alexandria_bytes::BytesTrait;
use core::bytes_31::{Bytes31IntoFelt252, bytes31_to_felt252};

// Celestia-app namespace ID and its version
// See: https://celestiaorg.github.io/celestia-app/specs/namespace.html
struct NamespaceNode {
    min: Namespace,
    max: Namespace,
    // Node value.
    digest: u256,
}

#[derive(Drop, Copy)]
struct Namespace {
    version: u8,
    id: bytes31, //TODO: #28
}

trait NamespaceBytesTrait<Namespace>{
    fn to_bytes(self:@Namespace)-> Bytes;
    fn to_keccak(self:@Namespace)-> u256;
}

impl NamespaceBytes of NamespaceBytesTrait<Namespace>  {
    // Transform namespace version and ID into bytes
    #[inline(always)]
    fn to_bytes(self:@Namespace)-> Bytes {
        let mut bytes: Bytes = BytesTrait::new(0, array![]);
        let version = *self.version.into() ;
        let id= bytes31_to_felt252(*self.id.try_into().unwrap());
        bytes.append_u8(version);
        bytes.append_felt252(id);
        bytes
    }
    #[inline(always)]
    fn to_keccak(self:@Namespace)-> u256 {
        let bytes= self.to_bytes();
        let keccak=bytes.keccak();
        keccak
    }
}

trait NamespaceEqTrait<Namespace>{
    fn eq(self:@Namespace, namespace:Namespace)-> bool;
    fn ne(self:@Namespace, namespace:Namespace)-> bool;
}

impl NamespaceEq of NamespaceEqTrait<Namespace>  {
    #[inline(always)]
    fn eq(self:@Namespace, namespace:Namespace)-> bool {
        let bytes= self.to_bytes();
        let keccak=bytes.keccak();
        let other_bytes=namespace.to_bytes();
        let keccak_2=other_bytes.keccak();
        keccak == keccak_2
    }

    fn ne(self:@Namespace, namespace:Namespace)-> bool {
        let bytes= self.to_bytes();
        let keccak=bytes.keccak();
        let other_bytes=namespace.to_bytes();
        let keccak_2=other_bytes.keccak();
        keccak != keccak_2
    }
}
// TODO: #28
// impl NamespacePartialOrd of PartialOrd<Namespace> {
//     #[inline(always)]
//     fn le(lhs: Namespace, rhs: Namespace) -> bool {
//     }
//     #[inline(always)]
//     fn ge(lhs: Namespace, rhs: Namespace) -> bool {
//     }
//     #[inline(always)]
//     fn lt(lhs: Namespace, rhs: Namespace) -> bool {
//     }
//     #[inline(always)]
//     fn gt(lhs: Namespace, rhs: Namespace) -> bool {
//     }
// }

// impl NamespacePartialEq of PartialEq<Namespace> {
//     #[inline(always)]
//     fn eq(lhs: @Namespace, rhs: @Namespace) -> bool {
//     }
//     #[inline(always)]
//     fn ne(lhs: @Namespace, rhs: @Namespace) -> bool {
//     }
// }

// // compares two `NamespaceNode`s
// fn namespace_node_eq(first: NamespaceNode, second: NamespaceNode) -> bool {
//     return first.min.eq(second.min) && first.max.eq(second.max) && (first.digest == second.digest);
// }


