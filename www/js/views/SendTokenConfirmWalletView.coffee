class SendTokenConfirmWalletView extends BaseView
  constructor: ()->
    super("SendTokenConfirmWalletView")

    @template = @tmpl
    @evtHandler = new SendTokenConfirmWalletEvtHandler(@)
    @evtHandler.net.bindEvtToLink "getEthPriceEur", NetEvtLinks.rest.Utils.ethPriceEur

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "SendTokenWalletView"})
    $('body').css "background-image", "url('img/gatewaybg.jpg')"
    
    #get eth price in euro...
    @evtHandler.net.get "getEthPriceEur"

    trace "data sent to view incoming..."
    trace data
    trace JSON.stringify data
    trace data.sendObj
    trace JSON.stringify data.sendObj

    which = data.sendObj.token
    from = data.sendObj.fromAddress
    to = data.sendObj.toAddress
    amount = data.sendObj.amount

    $('#which').text which + " Transaction"
    $('#from').text from
    $('#to').text to
    $('#amount').text amount


    CWUtils._web3.eth.defaultAccount = from


    trace "initiating EG contract..."
    abiVar = '[{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burn","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_subtractedValue","type":"uint256"}],"name":"decreaseApproval","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"burnFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_addedValue","type":"uint256"}],"name":"increaseApproval","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_initialSupply","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Burn","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"}]'
    abiVar = JSON.parse abiVar
    AppProps.EGContract = CWUtils._web3.eth.contract(abiVar)
    trace "after..."
    trace typeof AppProps.EGContract
    trace AppProps.EGContract

#    trace "work ON contract..."
#    vari = AppProps.EGContract.approve.estimateGas(from, "0x0EA1A9Bf2dAbD82E6A920D7bACd1339838A55b31")
#    trace "after..."
#    trace typeof vari
#    trace vari

    trace "initiating EGC..."
    AppProps.EGC = AppProps.EGContract.at(AppProps.contracts[which])
    trace "after..."
    trace typeof AppProps.EGC
    trace AppProps.EGC


#    trace "gonna estimate gas..."
##    estGas = AppProps.EGC.approve.estimateGas("0x0EA1A9Bf2dAbD82E6A920D7bACd1339838A55b31", 1)
##    estGas = AppProps.EGC.transferFrom.estimateGas(from, to, 1)
#    amt = "1" + "000000000000000000";
#    estGas = AppProps.EGC.transfer.estimateGas(to, amt)
#    trace "after estimate gas..."
#    trace estGas
#
#    gp = CWUtils._web3.eth.gasPrice
#    trace "gas price in wei is " + gp
#
#    gpf = (estGas * gp)
#    trace "tx fee is " + gpf
#    gasPriceEther = CWUtils._web3.fromWei(gpf.toString(), "ether")
#    trace "tx fee in Ether is " + gasPriceEther
#    $('#txfee').append gasPriceEther + " ETH"


    $('p, span').click ->
      switch $(this).attr("id")
        when "from" then return navigator.notification.alert(from, null, "From Address", "OK")
        when "to" then return navigator.notification.alert(to, null, "To Address", "OK")
        when "amount" then return navigator.notification.alert(amount, null, "Amount", "OK")

    trace CWUtils._web3
    $('#confirm').click ->
      trace "confirm clicked !"

      d = {}
      d.gasLimit = CWUtils._web3.toHex estGas
      d.gasPrice = CWUtils._web3.toHex gp

      d.data = AppProps.EGC.transfer.getData(to, amt)

      trace "got transfer data..."
      trace d.data

      d.from = from
      d.to = AppProps.contracts.EuroGolld

      d.nonce = CWUtils._web3.toHex(CWUtils._web3.eth.getTransactionCount(from))


      trace "d incoming..."
      trace d

      tx = new ethTx(d)
      trace "tx incoming..."
      trace tx

      tx.sign(ethUtils.toBuffer(AppProps.get("tgwpk"), "hex"))
      trace "tx incoming..."
      trace tx

      stx = tx.serialize()
      trace "stx incoming..."
      trace stx

      stx = stx.toString("hex")
      trace "stx incoming..."
      trace stx

      stx = "0x" + stx

      res = CWUtils._web3.eth.sendRawTransaction stx
      trace "res incoming..."
      trace res

  ###
    contractAddress = AppProps.contracts[which]
    trace "contract address for " + which + " is " + contractAddress
    count = CWUtils._web3.eth.getTransactionCount(from)
    trace "number of transactions from " + from + " so far is " + count
    balance = data.sendObj.myCurrentBalance
    trace "my current balance is " + balance

    gp = CWUtils._web3.eth.gasPrice
    gasPriceGwei = CWUtils._web3.fromWei(gp.toString(), "Gwei")
    trace "Current gas price in Gwei is " + gasPriceGwei
    gasPriceEther = CWUtils._web3.fromWei(gp.toString(), "ether")
    trace "Current gas price in Ether is " + gasPriceEther

    estGasObj = {}
    trace "getting 'trans'..."
#    trans = ethUtils.sha3('transfer(address, uint256)')
    trans = ethUtils.sha3('allowance(address, address)')
    trace trans
    trans = ethUtils.bufferToHex(trans)
    trace trans
    trans = trans.substring(0, 10)
    trace trans

#    testAddress = "0xAAd15379235c05bFC897286db3164eccb3ac4082"

#    estGasObj.data = trans + "000000000000000000000000" + from.substring(2) + "000000000000000000000000" + testAddress.substring(2)
    estGasObj.data = trans + "000000000000000000000000" + from.substring(2) + "000000000000000000000000" + to.substring(2)
    estGasObj.to = contractAddress

    trace estGasObj

    trace "getting gas estimate..."
    gasEstimate = CWUtils._web3.eth.estimateGas(estGasObj)
    trace gasEstimate
  ###


  tmpl: (data) ->
    """
      <div class="has-header">

        <ul class="list" style='margin: 5%;'>
          <h2 id='which' style='font-weight: bold'></h2>
          <li class='item' style='line-height: 160%'>
            <p style='font-style: italic;'>From</p>
            <p style='font-weight: bold' id='from'></p>
          </li>
          <li class='item' style='line-height: 160%'>
            <p style='font-style: italic;'>To</p>
            <p style='font-weight: bold' id='to'></p>
          </li>
          <li class='item' style='line-height: 160%'>
            <p style='font-style: italic;'>Amount</p>
            <p style='font-weight: bold'><span id='amount'></span></p>
          </li>
          <li class='item' style='line-height: 160%'>
            <p style='font-style: italic;' id='txfee'>Estimated transaction fee: </p>
          </li>

          <button id="confirm" class='button button-block button-assertive' style='float: right; margin-top: 5px;'>Confirm</button>
        </ul>

      </div>
    """
