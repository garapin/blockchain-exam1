//SPDX-License-Identifier: MIT

// contracts/BuyMeACoffee.sol
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract BuyMeACoffee {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }
    
    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable owner;
    address payable public constant specificAddress = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = payable(msg.sender);
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "can't buy coffee for free!");

        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(owner.send(address(this).balance));
    }

    /**
 * @dev Send a specified amount of Ether from the contract to the owner.
 * @param amount The amount of Ether to withdraw (in wei).
 */
/**
 * @dev Allows the owner to withdraw a specific amount of Ether to their own address.
 * @param amount The amount of Ether to withdraw (in wei).
 */

/**
 * @dev Allows the owner to withdraw the entire balance of the contract.
 */
/**
 * @dev Allows the owner to withdraw a specific amount of Ether to their address.
 * @param amount The amount of Ether to withdraw (in wei).
 */
event WithdrawSuccess(address indexed owner, uint256 amount);

function withdrawTips2(uint256 amount) public {
    require(msg.sender == owner, "Only the owner can withdraw funds");
    require(amount > 0, "Amount must be greater than zero");
    uint256 contractBalance = address(this).balance;
    require(amount <= contractBalance, "Insufficient balance in contract");

    console.log("Contract balance:", contractBalance);
    console.log("Requested amount:", amount);

    (bool success, ) = owner.call{value: amount}("");
    require(success, "Failed to send Ether to the owner");
}


}