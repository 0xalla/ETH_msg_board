pragma solidity >=0.7.0 <0.8.0;


contract MessageBoard {

    event Message(address indexed sender, string message);
    string helpMessage = "var d='your text here';var h='0xff';for(var i=0;i<d.length;i++){h+=d.charCodeAt(i).toString(16);};alert(h)";

    fallback() external payable {
        
        // first byte from message is used to determine message type 
        // ff means valid message and everything else is invalid
        // valid messages will be stored
        // and with invalid message helpMessage will be stored
        
        // example:
        // "ff48656c6c6f2045564d21" is valid and "48656c6c6f2045564d21" is invalid
        // ascii: Hello EVM!
         
        bytes memory msgIdentifier = new bytes(1);
        
        if (msg.data.length > 2) {
            msgIdentifier[0] = msg.data[0];
        } else {
            msgIdentifier[0] = byte(0x00);
        }

        if (msgIdentifier[0] == byte(0xff)) {
            // message is valid and it should be stored
            
            uint msgLen = msg.data.length - msgIdentifier.length;
            bytes memory output = new bytes(msgLen);
            
            for (uint i = 0; i < msgLen; i++) {
                output[i] = msg.data[i + msgIdentifier.length];
            }
            
            string memory result = string(output);
            emit Message(msg.sender, result);
            
        } else {
            // message is invalid and helpMessage should be stored
            
            emit Message(msg.sender, helpMessage);
        }
        
        // if user sent any ether, it will be sent back
        if (msg.value > 0) {
            msg.sender.transfer(msg.value);
        }
    }
}
