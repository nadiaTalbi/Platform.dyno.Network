/*
 * SPDX-License-Identifier: Apache-2.0
 */
// Deterministic JSON.stringify()
import { Context, Contract, Info, Returns, Transaction } from 'fabric-contract-api';
import stringify from 'json-stringify-deterministic';
import sortKeysRecursive from 'sort-keys-recursive';
import { Asset } from './asset';

Info({ title: 'AssetTransfer', description: 'Smart contract for trading assets' })
export class ChanincodeContract extends Contract {

    public async InitLedger(ctx: Context): Promise<void> {
        const assets: Asset[] = [
            {
                PrivateKey: 'ABC',
                PublicAddress: 'a5ec0421-2fd4-4ded-831a-e1eaf0ec1fa2',
                Balance: 5,
            },
            {
                PrivateKey: 'DEF',
                PublicAddress: 'f35fe3a3-d870-4ed7-b2b0-70486411e509',
                Balance: 10,
            },
            {
                PrivateKey: 'GHS',
                PublicAddress: 'de7f0806-bd61-45b8-81f5-0e2132d8ed2e',
                Balance: 15,
            }
        ];

        for (const asset of assets) {
            // example of how to write to world state deterministically
            // use convetion of alphabetic order
            // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
            // when retrieving data, in any lang, the order of data will be the same and consequently also the corresonding hash
            await ctx.stub.putState(asset.PrivateKey, Buffer.from(stringify(sortKeysRecursive(asset))));
            console.info(`Asset ${asset.PrivateKey} initialized`);
        }
    }

    // CreateAsset issues a new asset to the world state with given details.
    public async CreateAsset(ctx: Context, privateKey: string, publicAddress: string, balance: number): Promise<void> {
        const exists = await this.AssetExists(ctx, privateKey);
        if (exists) {
            throw new Error(`The asset ${privateKey} already exists`);
        }
        const asset = {
            PrivateKey: privateKey,
            PublicAddress: publicAddress,
            Balance: balance,
        };
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        await ctx.stub.putState(privateKey, Buffer.from(stringify(sortKeysRecursive(asset))));
    }

    private getClientID(ctx: Context): string {
        return `${ctx.clientIdentity.getMSPID()}:${ctx.clientIdentity.getID()}`
    }

    // ReadAsset returns the asset stored in the world state with given id.
    public async ReadAsset(ctx: Context, privateKey: string): Promise<string> {
        const assetJSON = await ctx.stub.getState(privateKey); // get the asset from chaincode state
        if (!assetJSON || assetJSON.length === 0) {
            throw new Error(`The asset ${privateKey} does not exist`);
        }
        return assetJSON.toString();
    }

    public async readAsset(ctx: Context, id: string): Promise<Asset> {
        const assetJSON = await ctx.stub.getState(id); // get the asset from chaincode state
        if (!assetJSON || assetJSON.length === 0) {
            throw new Error(`The asset ${id} does not exist`);
        }
        return JSON.parse(assetJSON.toString()) as Asset;
    }

    // UpdateAsset updates an existing asset in the world state with provided parameters.
    public async UpdateAsset(ctx: Context, id: string, color: string, size: number, appraisedValue: number): Promise<void> {
        const exists = await this.AssetExists(ctx, id);
        if (!exists) {
            throw new Error(`The asset ${id} does not exist`);
        }
        const asset = await this.readAsset(ctx, id);
        // if (asset.Owner !== this.getClientID(ctx)) {
        //     throw new Error(`The asset ${id} is not owned by ${this.getClientID(ctx)}`);
        // }
        // overwriting original asset with new asset
        const updatedAsset = {
            ID: id,
            Color: color,
            Size: size
        };
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        return ctx.stub.putState(id, Buffer.from(stringify(sortKeysRecursive(updatedAsset))));
    }

    // DeleteAsset deletes an given asset from the world state.
    public async DeleteAsset(ctx: Context, id: string): Promise<void> {
        const exists = await this.AssetExists(ctx, id);
        if (!exists) {
            throw new Error(`The asset ${id} does not exist`);
        }
        const asset = await this.readAsset(ctx, id);

        // if (asset.Owner !== this.getClientID(ctx)) {
        //     throw new Error(`The asset ${id} is not owned by ${this.getClientID(ctx)}`);
        // }
        return ctx.stub.deleteState(id);
    }

    // AssetExists returns true when asset with given ID exists in world state.
    public async AssetExists(ctx: Context, id: string): Promise<boolean> {
        const assetJSON = await ctx.stub.getState(id);
        return assetJSON && assetJSON.length > 0;
    }

    // TransferAsset updates the owner field of asset with given id in the world state, and returns the old owner.
    public async TransferAsset(ctx: Context, id: string, newOwner: string): Promise<string> {

        const assetString = await this.ReadAsset(ctx, id);
        const asset = JSON.parse(assetString);
        if (asset.Owner !== this.getClientID(ctx)) {
            throw new Error(`The asset ${id} is not owned by ${this.getClientID(ctx)}`);
        }
        const oldOwner = asset.Owner;
        asset.Owner = newOwner;
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        await ctx.stub.putState(id, Buffer.from(stringify(sortKeysRecursive(asset))));
        return oldOwner;
    }

    // GetAllAssets returns all assets found in the world state.
    public async GetAllAssets(ctx: Context): Promise<string> {
        let allResults : any[] = [];
        // range query with empty string for startKey and endKey does an open-ended query of all assets in the chaincode namespace.
        const iterator = await ctx.stub.getStateByRange('', '');
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record: any;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);

            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }

}