//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

contract Issuer {
    address public dbadoy;
    string public prefix = "https://api.github.com/repos/";
    string public postfix = "contributors?"; // per_page=100&page=
    uint256 public ids = 1;

    string[] public prefixHistories;
    string[] public postfixHistories;

    mapping (uint256 => string) _urls;
    mapping (uint256 => string) _enrollSuject;
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
    function enroll(string memory subject, string memory owner, string memory repo) external returns (uint256) {
        string memory p = string.concat(prefix, owner, "/", repo, "/", postfix);
        _urls[ids] = p;
        _enrollSuject[ids] = subject;
        ids++;
        _repoTotalEnrolls[string.concat(owner, "/", repo)]++;
        emit Enroll(ids - 1, p);
        return ids - 1;
    }

    // verify flow
    // 1. getURL from Issuer contracts
    // 2. get contiributors list (list length: n = undefined)
    // 3. if _enrollSubject exist that list: true
    // 4. else: false
    // -----------------------------------------------------------------------------------
    // in badge-viewer: service explorer.
    // in html-converter(or something): provides library that helps verify flow to easily 
    function getURL(uint256 id) external view returns (string memory, string memory) {
        return (_urls[id], _enrollSuject[id]);
    }

    function getRepoEnrollCount(string memory owner, string memory repo) external view returns (uint256) {
        return _repoTotalEnrolls[string.concat(owner, "/", repo)];
    }

    function getUrlTokenPair(uint256 index) external view returns (string memory, string memory) {
        require(prefixHistories.length == postfixHistories.length, "it's may never called");
        return (prefixHistories[index], postfixHistories[index]);
    } 
}