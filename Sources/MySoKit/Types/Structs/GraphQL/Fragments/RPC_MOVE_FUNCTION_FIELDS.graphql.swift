// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RPC_MOVE_FUNCTION_FIELDS: MySoKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RPC_MOVE_FUNCTION_FIELDS on MoveFunction { __typename name visibility isEntry parameters { __typename signature } typeParameters { __typename constraints } return { __typename repr signature } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveFunction }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("name", String.self),
    .field("visibility", GraphQLEnum<MySoKit.MoveVisibility>?.self),
    .field("isEntry", Bool?.self),
    .field("parameters", [Parameter]?.self),
    .field("typeParameters", [TypeParameter]?.self),
    .field("return", [Return]?.self)
  ] }

  /// The function's (unqualified) name.
  public var name: String { __data["name"] }
  /// The function's visibility: `public`, `public(friend)`, or `private`.
  public var visibility: GraphQLEnum<MySoKit.MoveVisibility>? { __data["visibility"] }
  /// Whether the function has the `entry` modifier or not.
  public var isEntry: Bool? { __data["isEntry"] }
  /// The function's parameter types.  These types can reference type parameters introduce by this
  /// function (see `typeParameters`).
  public var parameters: [Parameter]? { __data["parameters"] }
  /// Constraints on the function's formal type parameters.  Move bytecode does not name type
  /// parameters, so when they are referenced (e.g. in parameter and return types) they are
  /// identified by their index in this list.
  public var typeParameters: [TypeParameter]? { __data["typeParameters"] }
  /// The function's return types.  There can be multiple because functions in Move can return
  /// multiple values.  These types can reference type parameters introduced by this function (see
  /// `typeParameters`).
  public var `return`: [Return]? { __data["return"] }

  /// Parameter
  ///
  /// Parent Type: `OpenMoveType`
  public struct Parameter: MySoKit.SelectionSet {
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

  /// TypeParameter
  ///
  /// Parent Type: `MoveFunctionTypeParameter`
  public struct TypeParameter: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveFunctionTypeParameter }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("constraints", [GraphQLEnum<MySoKit.MoveAbility>].self)
    ] }

    public var constraints: [GraphQLEnum<MySoKit.MoveAbility>] { __data["constraints"] }
  }

  /// Return
  ///
  /// Parent Type: `OpenMoveType`
  public struct Return: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.OpenMoveType }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("repr", String.self),
      .field("signature", AnyHashable.self)
    ] }

    /// Flat representation of the type signature, as a displayable string.
    public var repr: String { __data["repr"] }
    /// Structured representation of the type signature.
    public var signature: AnyHashable { __data["signature"] }
  }
}
