class SendTokenConfirmWalletEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in send token confirm wallet evthandler"

    if name is "getEthPriceEur"
      trace data
      trace "gonna estimate gas..."
      #    estGas = AppProps.EGC.approve.estimateGas("0x0EA1A9Bf2dAbD82E6A920D7bACd1339838A55b31", 1)
      #    estGas = AppProps.EGC.transferFrom.estimateGas(from, to, 1)
      amt = "1" + "000000000000000000";
      estGas = AppProps.EGC.transfer.estimateGas(@view.to, amt)
      trace "after estimate gas..."
      trace estGas

      gp = CWUtils._web3.eth.gasPrice
      trace "gas price in wei is " + gp

      gpf = (estGas * gp)
      trace "tx fee is " + gpf
      gasPriceEther = CWUtils._web3.fromWei(gpf.toString(), "ether")
      trace "tx fee in Ether is " + gasPriceEther

      gasPriceEuro = parseFloat data * parseFloat gasPriceEther
      gasPriceEuro = gasPriceEuro.toFixed(6)
      
      $('#txfee').html $('#txfee').text() + gasPriceEther + " ETH <br>or " + gasPriceEuro + " EUR"

    if name is 'error'
      trace "error : " + data
      trace data