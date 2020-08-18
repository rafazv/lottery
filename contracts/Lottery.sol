pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address public lastWinner;
    address[] public players;

    constructor() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether);

        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, now, players))
            ); // algorithm for random numbers; i need to pass some argumnets for produce this random number
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        players[index].transfer(address(this).balance); // this.balance: todo o dinheiro que o contrato possui
        lastWinner = players[index];

        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}
