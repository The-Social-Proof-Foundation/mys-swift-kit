// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RPC_MOVE_STRUCT_FIELDS: MySoKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RPC_MOVE_STRUCT_FIELDS on MoveStruct { __typename name abilities fields { __typename name type { __typename signature } } typeParameters { __typename isPhantom constraints } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveStruct }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("name", String.self),
    .field("abilities", [GraphQLEnum<MySoKit.MoveAbility>]?.self),
    .field("fields", [Field]?.self),
    .field("typeParameters", [TypeParameter]?.self)
  ] }

  /// The struct's (unqualified) type name.
  public var name: String { __data["name"] }
  /// Abilities this struct has.
  public var abilities: [GraphQLEnum<MySoKit.MoveAbility>]? { __data["abilities"] }
  /// The names and types of the struct's fields.  Field types reference type parameters, by their
  /// index in the defining struct's `typeParameters` list.
  public var fields: [Field]? { __data["fields"] }
  /// Constraints on the struct's formal type parameters.  Move bytecode does not name type
  /// parameters, so when they are referenced (e.g. in field types) they are identified by their
  /// index in this list.
  public var typeParameters: [TypeParameter]? { __data["typeParameters"] }

  /// Field
  ///
  /// Parent Type: `MoveField`
  public struct Field: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveField }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
      .field("type", Type_SelectionSet?.self)
    ] }

    public var name: String { __data["name"] }
    public var type: Type_SelectionSet? { __data["type"] }

    /// Field.Type_SelectionSet
    ///
    /// Parent Type: `OpenMoveType`
    public struct Type_SelectionSet: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.OpenMoveType }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("signature", AnyHashable.self)
      ] }

      /// Structured representation of the type signature.
      public var signature: AnyHashable { __data["signature"] }
    }
  }

  /// TypeParameter
  ///
  /// Parent Type: `MoveStructTypeParameter`
  public struct TypeParameter: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveStructTypeParameter }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("isPhantom", Bool.self),
      .field("constraints", [GraphQLEnum<MySoKit.MoveAbility>].self)
    ] }

    public var isPhantom: Bool { __data["isPhantom"] }
    public var constraints: [GraphQLEnum<MySoKit.MoveAbility>] { __data["constraints"] }
  }
}
