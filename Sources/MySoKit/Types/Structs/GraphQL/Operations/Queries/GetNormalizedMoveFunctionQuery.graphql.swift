// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetNormalizedMoveFunctionQuery: GraphQLQuery {
  public static let operationName: String = "getNormalizedMoveFunction"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getNormalizedMoveFunction($packageId: MysAddress!, $module: String!, $function: String!) { object(address: $packageId) { __typename address asMovePackage { __typename module(name: $module) { __typename fileFormatVersion function(name: $function) { __typename ...RPC_MOVE_FUNCTION_FIELDS } } } } }"#,
      fragments: [RPC_MOVE_FUNCTION_FIELDS.self]
    ))

  public var packageId: MySoAddressApollo
  public var module: String
  public var function: String

  public init(
    packageId: MySoAddressApollo,
    module: String,
    function: String
  ) {
    self.packageId = packageId
    self.module = module
    self.function = function
  }

  public var __variables: Variables? { [
    "packageId": packageId,
    "module": module,
    "function": function
  ] }

  public struct Data: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("object", Object?.self, arguments: ["address": .variable("packageId")])
    ] }

    /// The object corresponding to the given address at the (optionally) given version.
    /// When no version is given, the latest version is returned.
    public var object: Object? { __data["object"] }

    /// Object
    ///
    /// Parent Type: `Object`
    public struct Object: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Object }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("address", MySoKit.MySoAddressApollo.self),
        .field("asMovePackage", AsMovePackage?.self)
      ] }

      public var address: MySoKit.MySoAddressApollo { __data["address"] }
      /// Attempts to convert the object into a MovePackage
      public var asMovePackage: AsMovePackage? { __data["asMovePackage"] }

      /// Object.AsMovePackage
      ///
      /// Parent Type: `MovePackage`
      public struct AsMovePackage: MySoKit.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MovePackage }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("module", Module?.self, arguments: ["name": .variable("module")])
        ] }

        /// A representation of the module called `name` in this package, including the
        /// structs and functions it defines.
        public var module: Module? { __data["module"] }

        /// Object.AsMovePackage.Module
        ///
        /// Parent Type: `MoveModule`
        public struct Module: MySoKit.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveModule }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("fileFormatVersion", Int.self),
            .field("function", Function?.self, arguments: ["name": .variable("function")])
          ] }

          /// Format version of this module's bytecode.
          public var fileFormatVersion: Int { __data["fileFormatVersion"] }
          /// Look-up the signature of a function defined in this module, by its name.
          public var function: Function? { __data["function"] }

          /// Object.AsMovePackage.Module.Function
          ///
          /// Parent Type: `MoveFunction`
          public struct Function: MySoKit.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveFunction }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(RPC_MOVE_FUNCTION_FIELDS.self)
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

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var rPC_MOVE_FUNCTION_FIELDS: RPC_MOVE_FUNCTION_FIELDS { _toFragment() }
            }

            public typealias Parameter = RPC_MOVE_FUNCTION_FIELDS.Parameter

            public typealias TypeParameter = RPC_MOVE_FUNCTION_FIELDS.TypeParameter

            public typealias Return = RPC_MOVE_FUNCTION_FIELDS.Return
          }
        }
      }
    }
  }
}
