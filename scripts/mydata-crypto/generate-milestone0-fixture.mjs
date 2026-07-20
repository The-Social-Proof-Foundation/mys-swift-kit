#!/usr/bin/env node
/**
 * Regenerate Milestone 0 fixture from @socialproof/mydata (canonical protocol).
 * Run from chat-app after `pnpm install`, or with NODE_PATH pointing at mydata.
 */
import { writeFileSync } from 'fs';
import { encrypt, KemType } from '@socialproof/mydata';
import { pathToFileURL } from 'url';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
// Resolve dem/decrypt internals relative to installed package when run via pnpm
const mydataRoot = require.resolve('@socialproof/mydata/package.json').replace(/package\.json$/, '');
const { AesGcm256 } = await import(pathToFileURL(mydataRoot + 'dist/dem.mjs'));
const { decrypt } = await import(pathToFileURL(mydataRoot + 'dist/decrypt.mjs'));
const { EncryptedObject } = await import(pathToFileURL(mydataRoot + 'dist/bcs.mjs'));
const { G1Element, G2Element, Scalar } = await import(pathToFileURL(mydataRoot + 'dist/bls12381.mjs'));
const { hashToG1 } = await import(pathToFileURL(mydataRoot + 'dist/kdf.mjs'));
const { createFullId } = await import(pathToFileURL(mydataRoot + 'dist/utils.mjs'));
const { fromHex, toHex } = await import('@socialproof/bcs');

const mk1 = Scalar.fromBytes(new Uint8Array(32).fill(1));
const mk2 = Scalar.fromBytes(new Uint8Array(32).fill(2));
const pk1 = G2Element.generator().multiply(mk1);
const pk2 = G2Element.generator().multiply(mk2);
const server1 = '0x' + '11'.repeat(32);
const server2 = '0x' + '22'.repeat(32);
const packageId = '0x' + 'aa'.repeat(32);
const identity = 'bb'.repeat(32) + '0100000000000000';
const plaintext = new Uint8Array(32).fill(0x42);
const { encryptedObject } = await encrypt({
  keyServers: [
    { objectId: server1, pk: pk1.toBytes(), weight: 1 },
    { objectId: server2, pk: pk2.toBytes(), weight: 1 },
  ],
  kemType: KemType.BonehFranklinBLS12381DemCCA,
  threshold: 2,
  packageId,
  id: identity,
  encryptionInput: new AesGcm256(plaintext),
});
const parsed = EncryptedObject.parse(encryptedObject);
const fullId = createFullId(packageId, identity);
const gid = hashToG1(fromHex(fullId));
const usk1 = gid.multiply(mk1);
const usk2 = gid.multiply(mk2);
await decrypt({
  encryptedObject: parsed,
  keys: new Map([
    [`${fullId}:${server1}`, usk1],
    [`${fullId}:${server2}`, usk2],
  ]),
});
const out = {
  encryptedObjectHex: toHex(encryptedObject),
  plaintextHex: toHex(plaintext),
  packageId,
  identity,
  fullId,
  server1,
  server2,
  usk1Hex: toHex(usk1.toBytes()),
  usk2Hex: toHex(usk2.toBytes()),
  g1GeneratorHex: toHex(G1Element.generator().toBytes()),
  g2GeneratorHex: toHex(G2Element.generator().toBytes()),
  hashToG1FullIdHex: toHex(gid.toBytes()),
};
const dest = new URL('../Tests/MyDataCryptoTests/Fixtures/milestone0.json', import.meta.url);
writeFileSync(dest, JSON.stringify(out, null, 2));
console.log('Wrote', dest.pathname);
