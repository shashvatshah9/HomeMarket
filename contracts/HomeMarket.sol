// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract PropertyMarket {
	event TradeStatusChange(uint256 ad, bytes32 status);

	IERC20 currencyToken;
	IERC721 itemToken;

	struct Trade {
		address propAdr;
		uint256 item;
		uint256 price;
		bytes32 exchangeType; // Transfered, Leased, Inherit, Hold
	}

	mapping(uint256 => Trade) public trades;

	uint256 tradeCounter;

	constructor(address _currenyTokenAddress, address _itemTokenAddress) public virtual {
		currencyToken = IRC20(_currencyTokenAddress);
		itemToken = IERC721(_itemTokenAddress);
		tradeCounter = 0;
	}

	function getTrade(uint256 _trade)
		public
		view
		virtual
		returns (
			address,
			uint256,
			uint256,
			bytes32
		)
	{
		Trade memory trade = trades[_trade];
		return (trade.propAdr, trade.item, trade.price, trade.status);
	}

	function createTrade(uint256 _item, uint256 _price) public virtual {
		itemToken.transferFrom(msg.sender, address(this), _item);
		trades[tradeCounter] = Trade({
			propAdr: msg.sender,
			item: _item,
			price: _price,
			stutus: "hold"
		});
		tradeCounter += 1;
		emit TradeStatusChange(tradeCounter - 1, "hold");
	}
}
