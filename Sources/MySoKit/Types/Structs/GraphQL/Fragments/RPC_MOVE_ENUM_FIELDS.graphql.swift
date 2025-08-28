// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RPC_MOVE_ENUM_FIELDS: MySoKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RPC_MOVE_ENUM_FIELDS on MoveEnum { __typename name abilities typeParameters { __typename isPhantom constraints } variants { __typename name fields { __typename name type { __typename signature } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveEnum }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("name", String.self),
    .field("abilities", [GraphQLEnum<MySoKit.MoveAbility>]?.self),
    .field("typeParameters", [TypeParameter]?.self),
    .field("variants", [Variant]?.self)
  ] }

  /// The enum's (unqualified) type name.
  public var name: String { __data["name"] }
  /// The enum's abilities.
  public var abilities: [GraphQLEnum<MySoKit.MoveAbility>]? { __data["abilities"] }
  /// Constraints on the enum's formal type parameters.  Move bytecode does not name type
  /// parameters, so when they are referenced (e.g. in field types) they are identified by their
  /// index in this list.
  public var typeParameters: [TypeParameter]? { __data["typeParameters"] }
  /// The names and types of the enum's fields.  Field types reference type parameters, by their
  /// index in the defining enum's `typeParameters` list.
  public var variants: [Variant]? { __data["variants"] }

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

  /// Variant
  ///
  /// Parent Type: `MoveEnumVariant`
  public struct Variant: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveEnumVariant }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
      .field("fields", [Field]?.self)
    ] }

    /// The name of the variant
    public var name: String { __data["name"] }
    /// The names and types of the variant's fields.  Field types reference type parameters, by their
    /// index in the defining enum's `typeParameters` list.
    public var fields: [Field]? { __data["fields"] }

    /// Variant.Field
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

      /// Variant.Field.Type_SelectionSet
      ///
      /// Parent Type: `OpenMoveType`
      public struct Type_SelectionSet: MySoKit.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.OpenMoveType }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("signature", MySoKit.OpenMoveTypeSignatureApollo.self)
        ] }

        /// Structured representation of the type signature.
        public var signature: MySoKit.OpenMoveTypeSignatureApollo { __data["signature"] }
      }
    }
  }
}
