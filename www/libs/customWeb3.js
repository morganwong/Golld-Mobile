
console.log("In Customer Web3 dot js !");

console.log("ethereumjs incoming...");
console.log(ethereumjs);

var ethWallet = ethereumjs.Wallet;
if(ethWallet != null){
    console.log("'ethWallet' found");
    console.log(ethWallet);
}

var ethUtils = ethereumjs.Util;
if(ethUtils != null){
    console.log("'ethUtils' found");
    console.log(ethUtils);
}

var ethTx = ethereumjs.Tx;
if(ethTx != null){
    console.log("'ethTx' found");
    console.log(ethTx);
}

var ethBuffer = ethereumjs.Buffer;
if(ethBuffer != null){
    console.log("'ethBuffer' found");
    console.log(ethBuffer);
}

var CWUtils = {
    generatePin : function(){
        var pin = Math.floor((Math.random() * 10)) + "";
        while(pin.length < 4){
            pin += Math.floor((Math.random() * 10)) + "";
        }

        return pin;
    },
    _web3 : {}
}
