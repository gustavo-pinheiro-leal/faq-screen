public with sharing class FAQController {
    public FAQController() {}

    @AuraEnabled
    public static FAQResponse.Response loadFAQ(Integer numberOfRecords, Integer pageSize){
        try{
            List<FAQ__c> FAQList = [
                SELECT Id, Question__c, Answer__c
                FROM FAQ__c
                ORDER BY Question__c ASC
                LIMIT: pageSize
                OFFSET: numberOfRecords
            ];
    
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