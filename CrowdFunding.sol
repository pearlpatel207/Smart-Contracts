pragma solidity >=0.6.0 < 0.7.0;

struct Funder{
    
    address addr;
    uint amount;
}

contract CrowdFunding{
    
    struct Campaign {
        address payable beneficiary;
        uint fundingGoal;
        
        uint numFunders;
        uint amount;
        
        mapping(uint => Funder) funders;
    }
    
    uint numCampaigns;
    mapping(uint => Campaign) campaigns;
    
    // create a new campaign
    function newCampaign(address payable beneficiary, uint goal)
        public returns(uint campaignID) {
            
            campaignID = numCampaigns++;
            
            campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
        }
        
    //contribute to the Campaign
    function contribute(uint campaignID)
        public payable {
            Campaign storage c = campaigns[campaignID];
            c.funders[c.numFunders++] = Funder(
                {
                    addr: msg.sender,
                    amount: msg.value
                }
                );
                
            c.amount +=msg.value;
                
        }
        
        //check fundingGoal has reached
        function checkGoalReached(uint campaignID)
            public returns(bool reached) {
                
                Campaign storage c = campaigns[campaignID];
                
                if(c.amount < c.fundingGoal)
                    return false;
                    
                //reached the goal
                uint amount = c.amount;
                c.amount = 0;
                
                c.beneficiary.transfer(amount);
                
                return true;
                
            }
}
