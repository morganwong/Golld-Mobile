NetEvtLinks = {

	"photos":{
	},
	"links":{
	},
	"hateoas": {
	},
	"rest": {
		"AccountController": {
			"login":"#{AppProps.root}/accounts/login",
			"create":"#{AppProps.root}/accounts/create",
			"getaccount":"#{AppProps.root}/accounts/getAccount",
			"editaccount":"#{AppProps.root}/accounts/editdata",
			"uploadkycdocument":"#{AppProps.root}/accounts/uploadkycdocument"
			"uploadkycdocumentimg":"#{AppProps.root}/accounts/uploadkycdocumentimg"
			"fundaccount":"#{AppProps.root}/accounts/fundaccount"
			"fundaccountstripe":"#{AppProps.root}/accounts/fundaccountstripe"
			"accountfundpoll":"#{AppProps.root}/accounts/accountfundpoll"
			"getorders":"#{AppProps.root}/accounts/getOrders"
			"getfundorders":"#{AppProps.root}/accounts/getfundorders"

		}
		"OrderController": {
			"buyless":"#{AppProps.root}/orders/buylessorder"
			"makebuylessorderstripe":"#{AppProps.root}/orders/makebuylessorder_stripe"
			"pollfororder":"#{AppProps.root}/orders/pollfororder"
			"getorder":"#{AppProps.root}/orders/getorder"
#			"accountorder":"#{AppProps.root}/orders/accountorder"
#			"makeaccountorder":"#{AppProps.root}/orders/makeaccountorder"
		}
		"Utils": {
			"ethPriceEur":"#{AppProps.root}/coinmarketcap/ethPriceEur"
			"ethPriceUsd":"#{AppProps.root}/coinmarketcap/ethPriceUsd"
		}
	}
}
