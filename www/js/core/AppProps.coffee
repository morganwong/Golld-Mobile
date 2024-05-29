AppProps = {

#  root : "https://golldvouchers.herokuapp.com/m"
  root : "http://golldcore.herokuapp.com"
#  geth : "http://ec2-34-243-63-74.eu-west-1.compute.amazonaws.com:8545"
#  geth : "https://ropsten.infura.io/v3/ae762b88b8604165b7e275f1829a139c"
  geth : "https://ropsten.infura.io/v3/74b7cb3a94bf496ca933763090eecdd1"
  
  qrcodeep : "https://golldcore.herokuapp.com/qr/get/"

  contracts : {
    EuroGolld : "0xa3ed7de54f9d701f9aeb8707f4945463025abd6f"
    DollarGolld : "0x3acea64fe4aed7c537f9e5f1042e07ae1b58157b"
    PoundGolld : "0x9c68f88ad93e919e84e0ac2473c9eb9a07c39d8f"
  }
  
  store : (k, v) -> localStorage.setItem(k, v)
  get : (k) -> localStorage.getItem(k)

  userMail : -> AppProps.getUserEmailFromLocalStorage()
  setUserMail : (e) ->
    localStorage.setItem('tg_q_114349yuym5z_', e)

  getUserEmailFromLocalStorage : () -> localStorage.getItem('tg_q_114349yuym5z_')

  logout : ->
    AppProps.setUserMail(null)
    AppProps.uid = null
    localStorage.clear()

}
