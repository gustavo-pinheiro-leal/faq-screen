public with sharing class FAQController {
    public FAQController() {}

    @AuraEnabled(cacheable=true)
    public static FAQResponse.Response loadFAQ(Integer pageNumber, Integer pageSize, String searchTerm){
        try{
            List<FAQ__c> FAQList;
            Integer offset = pageSize * (pageNumber - 1);

            if(String.isNotBlank(searchTerm)){
                searchTerm = '%' + searchTerm + '%';
                FAQList = [SELECT Id, Question__c, Answer__c
                FROM FAQ__c
                WHERE Question__c LIKE: searchTerm
                LIMIT: pageSize
                OFFSET: offset];
            }
            else {
                FAQList = [SELECT Id, Question__c, Answer__c
                FROM FAQ__c
                LIMIT: pageSize
                OFFSET: offset];
            }
            
            List<FAQVO> FAQVOList = convertToFAQVO(FAQList);

            FAQResponse.Response response = new FAQResponse.Response(false, '', JSON.serialize(FAQVOList));

            return response;
        }
        catch(Exception e){
            return new FAQResponse.Response(e);
        }
    }

    public static List<FAQVO> convertToFAQVO(List<FAQ__c> FAQList){
        List<FAQVO> FAQVOList = new List<FAQVO>();

        for(FAQ__c faq : FAQList){
            FAQVOList.add(new FAQVO(faq));
        }

        return FAQVOList;
    }

    public class FAQVO{
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Question {get; set;}
        @AuraEnabled public String Answer {get; set;}

        public FAQVO(FAQ__c faq){
            this.Id = faq.Id;
            this.Question = faq.Question__c;
            this.Answer = faq.Answer__c;
        }
    }
}
