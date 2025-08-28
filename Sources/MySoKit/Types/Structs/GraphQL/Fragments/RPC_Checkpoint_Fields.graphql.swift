// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RPC_Checkpoint_Fields: MySoKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RPC_Checkpoint_Fields on Checkpoint { __typename digest epoch { __typename epochId } rollingGasSummary { __typename computationCost storageCost storageRebate nonRefundableStorageFee } networkTotalTransactions previousCheckpointDigest sequenceNumber timestamp validatorSignatures transactionBlocks { __typename pageInfo { __typename hasNextPage endCursor } nodes { __typename digest } } endOfEpoch: transactionBlocks(last: 1, filter: { kind: SYSTEM_TX }) { __typename nodes { __typename kind { __typename ... on EndOfEpochTransaction { transactions(last: 1) { __typename nodes { __typename ... on ChangeEpochTransaction { epoch { __typename validatorSet { __typename activeValidators { __typename pageInfo { __typename hasNextPage endCursor } nodes { __typename credentials { __typename protocolPubKey } votingPower } } } protocolConfigs { __typename protocolVersion } epochId } } } } } } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Checkpoint }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("digest", String.self),
    .field("epoch", Epoch?.self),
    .field("rollingGasSummary", RollingGasSummary?.self),
    .field("networkTotalTransactions", MySoKit.UInt53Apollo?.self),
    .field("previousCheckpointDigest", String?.self),
    .field("sequenceNumber", MySoKit.UInt53Apollo.self),
    .field("timestamp", MySoKit.DateTimeApollo.self),
    .field("validatorSignatures", MySoKit.Base64Apollo.self),
    .field("transactionBlocks", TransactionBlocks.self),
    .field("transactionBlocks", alias: "endOfEpoch", EndOfEpoch.self, arguments: [
      "last": 1,
      "filter": ["kind": "SYSTEM_TX"]
    ])
  ] }

  /// A 32-byte hash that uniquely identifies the checkpoint contents, encoded in Base58. This
  /// hash can be used to verify checkpoint contents by checking signatures against the committee,
  /// Hashing contents to match digest, and checking that the previous checkpoint digest matches.
  public var digest: String { __data["digest"] }
  /// The epoch this checkpoint is part of.
  public var epoch: Epoch? { __data["epoch"] }
  /// The computation cost, storage cost, storage rebate, and non-refundable storage fee
  /// accumulated during this epoch, up to and including this checkpoint. These values increase
  /// monotonically across checkpoints in the same epoch, and reset on epoch boundaries.
  public var rollingGasSummary: RollingGasSummary? { __data["rollingGasSummary"] }
  /// The total number of transaction blocks in the network by the end of this checkpoint.
  public var networkTotalTransactions: MySoKit.UInt53Apollo? { __data["networkTotalTransactions"] }
  /// The digest of the checkpoint at the previous sequence number.
  public var previousCheckpointDigest: String? { __data["previousCheckpointDigest"] }
  /// This checkpoint's position in the total order of finalized checkpoints, agreed upon by
  /// consensus.
  public var sequenceNumber: MySoKit.UInt53Apollo { __data["sequenceNumber"] }
  /// The timestamp at which the checkpoint is agreed to have happened according to consensus.
  /// Transactions that access time in this checkpoint will observe this timestamp.
  public var timestamp: MySoKit.DateTimeApollo { __data["timestamp"] }
  /// This is an aggregation of signatures from a quorum of validators for the checkpoint
  /// proposal.
  public var validatorSignatures: MySoKit.Base64Apollo { __data["validatorSignatures"] }
  /// Transactions in this checkpoint.
  ///
  /// `scanLimit` restricts the number of candidate transactions scanned when gathering a page of
  /// results. It is required for queries that apply more than two complex filters (on function,
  /// kind, sender, recipient, input object, changed object, or ids), and can be at most
  /// `serviceConfig.maxScanLimit`.
  ///
  /// When the scan limit is reached the page will be returned even if it has fewer than `first`
  /// results when paginating forward (`last` when paginating backwards). If there are more
  /// transactions to scan, `pageInfo.hasNextPage` (or `pageInfo.hasPreviousPage`) will be set to
  /// `true`, and `PageInfo.endCursor` (or `PageInfo.startCursor`) will be set to the last
  /// transaction that was scanned as opposed to the last (or first) transaction in the page.
  ///
  /// Requesting the next (or previous) page after this cursor will resume the search, scanning
  /// the next `scanLimit` many transactions in the direction of pagination, and so on until all
  /// transactions in the scanning range have been visited.
  ///
  /// By default, the scanning range consists of all transactions in this checkpoint.
  public var transactionBlocks: TransactionBlocks { __data["transactionBlocks"] }
  /// Transactions in this checkpoint.
  ///
  /// `scanLimit` restricts the number of candidate transactions scanned when gathering a page of
  /// results. It is required for queries that apply more than two complex filters (on function,
  /// kind, sender, recipient, input object, changed object, or ids), and can be at most
  /// `serviceConfig.maxScanLimit`.
  ///
  /// When the scan limit is reached the page will be returned even if it has fewer than `first`
  /// results when paginating forward (`last` when paginating backwards). If there are more
  /// transactions to scan, `pageInfo.hasNextPage` (or `pageInfo.hasPreviousPage`) will be set to
  /// `true`, and `PageInfo.endCursor` (or `PageInfo.startCursor`) will be set to the last
  /// transaction that was scanned as opposed to the last (or first) transaction in the page.
  ///
  /// Requesting the next (or previous) page after this cursor will resume the search, scanning
  /// the next `scanLimit` many transactions in the direction of pagination, and so on until all
  /// transactions in the scanning range have been visited.
  ///
  /// By default, the scanning range consists of all transactions in this checkpoint.
  public var endOfEpoch: EndOfEpoch { __data["endOfEpoch"] }

  /// Epoch
  ///
  /// Parent Type: `Epoch`
  public struct Epoch: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Epoch }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("epochId", MySoKit.UInt53Apollo.self)
    ] }

    /// The epoch's id as a sequence number that starts at 0 and is incremented by one at every epoch change.
    public var epochId: MySoKit.UInt53Apollo { __data["epochId"] }
  }

  /// RollingGasSummary
  ///
  /// Parent Type: `GasCostSummary`
  public struct RollingGasSummary: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.GasCostSummary }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("computationCost", MySoKit.BigIntApollo?.self),
      .field("storageCost", MySoKit.BigIntApollo?.self),
      .field("storageRebate", MySoKit.BigIntApollo?.self),
      .field("nonRefundableStorageFee", MySoKit.BigIntApollo?.self)
    ] }

    /// Gas paid for executing this transaction (in MIST).
    public var computationCost: MySoKit.BigIntApollo? { __data["computationCost"] }
    /// Gas paid for the data stored on-chain by this transaction (in MIST).
    public var storageCost: MySoKit.BigIntApollo? { __data["storageCost"] }
    /// Part of storage cost that can be reclaimed by cleaning up data created by this transaction
    /// (when objects are deleted or an object is modified, which is treated as a deletion followed
    /// by a creation) (in MIST).
    public var storageRebate: MySoKit.BigIntApollo? { __data["storageRebate"] }
    /// Part of storage cost that is not reclaimed when data created by this transaction is cleaned
    /// up (in MIST).
    public var nonRefundableStorageFee: MySoKit.BigIntApollo? { __data["nonRefundableStorageFee"] }
  }

  /// TransactionBlocks
  ///
  /// Parent Type: `TransactionBlockConnection`
  public struct TransactionBlocks: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.TransactionBlockConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("pageInfo", PageInfo.self),
      .field("nodes", [Node].self)
    ] }

    /// Information to aid in pagination.
    public var pageInfo: PageInfo { __data["pageInfo"] }
    /// A list of nodes.
    public var nodes: [Node] { __data["nodes"] }

    /// TransactionBlocks.PageInfo
    ///
    /// Parent Type: `PageInfo`
    public struct PageInfo: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.PageInfo }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("hasNextPage", Bool.self),
        .field("endCursor", String?.self)
      ] }

      /// When paginating forwards, are there more items?
      public var hasNextPage: Bool { __data["hasNextPage"] }
      /// When paginating forwards, the cursor to continue.
      public var endCursor: String? { __data["endCursor"] }
    }

    /// TransactionBlocks.Node
    ///
    /// Parent Type: `TransactionBlock`
    public struct Node: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.TransactionBlock }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("digest", String?.self)
      ] }

      /// A 32-byte hash that uniquely identifies the transaction block contents, encoded in Base58.
      /// This serves as a unique id for the block on chain.
      public var digest: String? { __data["digest"] }
    }
  }

  /// EndOfEpoch
  ///
  /// Parent Type: `TransactionBlockConnection`
  public struct EndOfEpoch: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.TransactionBlockConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("nodes", [Node].self)
    ] }

    /// A list of nodes.
    public var nodes: [Node] { __data["nodes"] }

    /// EndOfEpoch.Node
    ///
    /// Parent Type: `TransactionBlock`
    public struct Node: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.TransactionBlock }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("kind", Kind?.self)
      ] }

      /// The type of this transaction as well as the commands and/or parameters comprising the
      /// transaction of this kind.
      public var kind: Kind? { __data["kind"] }

      /// EndOfEpoch.Node.Kind
      ///
      /// Parent Type: `TransactionBlockKind`
      public struct Kind: MySoKit.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Unions.TransactionBlockKind }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .inlineFragment(AsEndOfEpochTransaction.self)
        ] }

        public var asEndOfEpochTransaction: AsEndOfEpochTransaction? { _asInlineFragment() }

        /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction
        ///
        /// Parent Type: `EndOfEpochTransaction`
        public struct AsEndOfEpochTransaction: MySoKit.InlineFragment {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public typealias RootEntityType = RPC_Checkpoint_Fields.EndOfEpoch.Node.Kind
          public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.EndOfEpochTransaction }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("transactions", Transactions.self, arguments: ["last": 1])
          ] }

          /// The list of system transactions that are allowed to run at the end of the epoch.
          public var transactions: Transactions { __data["transactions"] }

          /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions
          ///
          /// Parent Type: `EndOfEpochTransactionKindConnection`
          public struct Transactions: MySoKit.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.EndOfEpochTransactionKindConnection }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("nodes", [Node].self)
            ] }

            /// A list of nodes.
            public var nodes: [Node] { __data["nodes"] }

            /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node
            ///
            /// Parent Type: `EndOfEpochTransactionKind`
            public struct Node: MySoKit.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MySoKit.Unions.EndOfEpochTransactionKind }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .inlineFragment(AsChangeEpochTransaction.self)
              ] }

              public var asChangeEpochTransaction: AsChangeEpochTransaction? { _asInlineFragment() }

              /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction
              ///
              /// Parent Type: `ChangeEpochTransaction`
              public struct AsChangeEpochTransaction: MySoKit.InlineFragment {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public typealias RootEntityType = RPC_Checkpoint_Fields.EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node
                public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ChangeEpochTransaction }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("epoch", Epoch?.self)
                ] }

                /// The next (to become) epoch.
                public var epoch: Epoch? { __data["epoch"] }

                /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch
                ///
                /// Parent Type: `Epoch`
                public struct Epoch: MySoKit.SelectionSet {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Epoch }
                  public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("validatorSet", ValidatorSet?.self),
                    .field("protocolConfigs", ProtocolConfigs.self),
                    .field("epochId", MySoKit.UInt53Apollo.self)
                  ] }

                  /// Validator related properties, including the active validators.
                  public var validatorSet: ValidatorSet? { __data["validatorSet"] }
                  /// The epoch's corresponding protocol configuration, including the feature flags and the
                  /// configuration options.
                  public var protocolConfigs: ProtocolConfigs { __data["protocolConfigs"] }
                  /// The epoch's id as a sequence number that starts at 0 and is incremented by one at every epoch change.
                  public var epochId: MySoKit.UInt53Apollo { __data["epochId"] }

                  /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch.ValidatorSet
                  ///
                  /// Parent Type: `ValidatorSet`
                  public struct ValidatorSet: MySoKit.SelectionSet {
                    public let __data: DataDict
                    public init(_dataDict: DataDict) { __data = _dataDict }

                    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ValidatorSet }
                    public static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("activeValidators", ActiveValidators.self)
                    ] }

                    /// The current set of active validators.
                    public var activeValidators: ActiveValidators { __data["activeValidators"] }

                    /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch.ValidatorSet.ActiveValidators
                    ///
                    /// Parent Type: `ValidatorConnection`
                    public struct ActiveValidators: MySoKit.SelectionSet {
                      public let __data: DataDict
                      public init(_dataDict: DataDict) { __data = _dataDict }

                      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ValidatorConnection }
                      public static var __selections: [ApolloAPI.Selection] { [
                        .field("__typename", String.self),
                        .field("pageInfo", PageInfo.self),
                        .field("nodes", [Node].self)
                      ] }

                      /// Information to aid in pagination.
                      public var pageInfo: PageInfo { __data["pageInfo"] }
                      /// A list of nodes.
                      public var nodes: [Node] { __data["nodes"] }

                      /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch.ValidatorSet.ActiveValidators.PageInfo
                      ///
                      /// Parent Type: `PageInfo`
                      public struct PageInfo: MySoKit.SelectionSet {
                        public let __data: DataDict
                        public init(_dataDict: DataDict) { __data = _dataDict }

                        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.PageInfo }
                        public static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("hasNextPage", Bool.self),
                          .field("endCursor", String?.self)
                        ] }

                        /// When paginating forwards, are there more items?
                        public var hasNextPage: Bool { __data["hasNextPage"] }
                        /// When paginating forwards, the cursor to continue.
                        public var endCursor: String? { __data["endCursor"] }
                      }

                      /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch.ValidatorSet.ActiveValidators.Node
                      ///
                      /// Parent Type: `Validator`
                      public struct Node: MySoKit.SelectionSet {
                        public let __data: DataDict
                        public init(_dataDict: DataDict) { __data = _dataDict }

                        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Validator }
                        public static var __selections: [ApolloAPI.Selection] { [
                          .field("__typename", String.self),
                          .field("credentials", Credentials?.self),
                          .field("votingPower", Int?.self)
                        ] }

                        /// Validator's set of credentials such as public keys, network addresses and others.
                        public var credentials: Credentials? { __data["credentials"] }
                        /// The voting power of this validator in basis points (e.g., 100 = 1% voting power).
                        public var votingPower: Int? { __data["votingPower"] }

                        /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch.ValidatorSet.ActiveValidators.Node.Credentials
                        ///
                        /// Parent Type: `ValidatorCredentials`
                        public struct Credentials: MySoKit.SelectionSet {
                          public let __data: DataDict
                          public init(_dataDict: DataDict) { __data = _dataDict }

                          public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ValidatorCredentials }
                          public static var __selections: [ApolloAPI.Selection] { [
                            .field("__typename", String.self),
                            .field("protocolPubKey", MySoKit.Base64Apollo?.self)
                          ] }

                          public var protocolPubKey: MySoKit.Base64Apollo? { __data["protocolPubKey"] }
                        }
                      }
                    }
                  }

                  /// EndOfEpoch.Node.Kind.AsEndOfEpochTransaction.Transactions.Node.AsChangeEpochTransaction.Epoch.ProtocolConfigs
                  ///
                  /// Parent Type: `ProtocolConfigs`
                  public struct ProtocolConfigs: MySoKit.SelectionSet {
                    public let __data: DataDict
                    public init(_dataDict: DataDict) { __data = _dataDict }

                    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ProtocolConfigs }
                    public static var __selections: [ApolloAPI.Selection] { [
                      .field("__typename", String.self),
                      .field("protocolVersion", MySoKit.UInt53Apollo.self)
                    ] }

                    /// The protocol is not required to change on every epoch boundary, so the protocol version
                    /// tracks which change to the protocol these configs are from.
                    public var protocolVersion: MySoKit.UInt53Apollo { __data["protocolVersion"] }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
