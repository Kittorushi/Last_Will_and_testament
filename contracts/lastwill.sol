//SPDX-License-Identifier:MIT

pragma solidity ^0.8.7;


contract change{

    constructor() payable {

        owner = msg.sender;
        funds = msg.value;
        isDeceased = false;

    }

    // get balance
    uint public balance = address(this).balance;

    // function getContractBalance(address ContractAddress) public view returns(uint){
    // return ContractAddress.balance;
    // }

    address owner ;
    uint funds ;
    bool isDeceased;
    bool checkBalanceFlag = false;
    

        struct Beneficiary {
                address payable beneficiaryAccounts;
                uint beneficiaryamount;
            }

        Beneficiary[] public Person;


        //event VoteCast(uint valOne, uint valTwo );

        modifier onlyOwner (){
            require(msg.sender == owner, "You are not the owner of the contract");
            _;
        }

        modifier isOwnerDeceased() {
            require(isDeceased== true, "Contract owner must be deceased for funds to be distriubuted");
            _;
        }

        modifier checkBalance(){
            require(checkBalanceFlag == true, "Insufficient Balance");
            _;
        }
        

        function benificerdetails(address payable beneficiaryAccounts, uint beneficiaryamount)  public {
        uint remainingToAllot = 0;
        if(address(this).balance > beneficiaryamount){

            for( uint j = 0 ; j< Person.length ; j++ ){

                remainingToAllot = Person[j].beneficiaryamount + remainingToAllot;
                //emit VoteCast(remainingToAllot , address(this).balance);
                }

                remainingToAllot = remainingToAllot + beneficiaryamount;

                if(remainingToAllot < address(this).balance  && (address(this).balance - remainingToAllot >= 0 )){
                    //Add beneficiary into struct
                    Person.push(Beneficiary(beneficiaryAccounts,beneficiaryamount));
            }
        }

    }


    // Distriubute all the funds to beneficiary
    function distriubuted() private isOwnerDeceased {
        for( uint i = 0 ; i< Person.length ; i++ ) {  
            (Person[i].beneficiaryAccounts).transfer(Person[i].beneficiaryamount);
        }
    }

    // get called only by the owner whe deceased
    function deceased() public onlyOwner {
        isDeceased = true;
        distriubuted();
    }

    // Coonvert Ether to Wei
    function etherToWei(uint valueEther) public pure returns (uint)
    {
        return valueEther*(10**18);
    }

}