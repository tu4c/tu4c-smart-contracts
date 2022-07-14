//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

contract Issuer {
    address public dbadoy;
    string public prefix = "https://api.github.com/repos/";
    string public postfix = "contributors?per_page=1&page=";
    uint256 public ids = 1;

    string[] public prefixHistories;
    string[] public postfixHistories;

    mapping (uint256 => string) _urls;
    mapping (string => uint256) _repoTotalEnrolls;

    event Enroll(uint256, string);
    event NewUrlTokenRule(string, string);

    constructor() {
        dbadoy = msg.sender;
        prefixHistories.push(prefix);
        postfixHistories.push(postfix);
    }

    function updateAdmin(address newAddr) external {
        require(dbadoy == msg.sender, "do updateAdmin only admin");
        dbadoy = newAddr;
    }

    function updateUrlToken(string memory newPrefix, string memory newPostfix) external {
        require(dbadoy == msg.sender, "do update url token, only admin");
        prefix = newPrefix;
        postfix = newPostfix;
        prefixHistories.push(prefix);
        postfixHistories.push(postfix);
        emit NewUrlTokenRule(newPrefix, newPostfix);
    }

    // you must remember enroll id. if you forget this, couldn't find it. 
    // in this case, you can loop [1 to latest enroll id] all enrolls id OR enroll again. 
    function enroll(string memory owner, string memory repo, uint8 pageNum) external returns (uint256) {
        string memory p = string.concat(prefix, owner, "/", repo, "/", postfix, toString(pageNum));
        _urls[ids] = p;
        ids++;
        _repoTotalEnrolls[string.concat(owner, "/", repo)]++;
        emit Enroll(ids - 1, p);
        return ids - 1;
    }

    function getURL(uint256 id) external view returns (string memory) {
        return _urls[id];
    }

    function getRepoEnrollCount(string memory owner, string memory repo) external view returns (uint256) {
        return _repoTotalEnrolls[string.concat(owner, "/", repo)];
    }

    function getUrlTokenPair(uint256 index) external view returns (string memory, string memory) {
        require(prefixHistories.length == postfixHistories.length, "it's may never called");
        // require(index > prefixHistories.length, "index overflow");
        return (prefixHistories[index], postfixHistories[index]);
    } 

    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol#L15-L35
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}