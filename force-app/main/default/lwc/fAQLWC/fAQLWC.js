import { LightningElement, api, track } from 'lwc';
import loadFAQ from '@salesforce/apex/FAQController.loadFAQ';

export default class FAQLWC extends LightningElement {
    @track faqs = [];
    @track searchResults = [];
    timer;
    numberOfRecords = 0;
    pageSize = 2;

    connectedCallback(){
        this.loadFAQs();
    }

    async loadFAQs(){
        let response = await loadFAQ({numberOfRecords: this.numberOfRecords, pageSize: this.pageSize});
        this.faqs = [...this.faqs, ...JSON.parse(response.ResponseJSON)];
        this.searchResults = this.faqs;
        this.numberOfRecords += JSON.parse(response.ResponseJSON).length;

    }


    handleSearch(event){
        const searchTerm = event.target.value.toLowerCase();

        if(this.timer){
            clearTimeout(this.timer);
        }

        this.timer = setTimeout(() => {
            this.searchItems(searchTerm);
        }, 1000);
    }

    handleLoadMore(){
        this.loadFAQs();
    }

    searchItems(searchTerm){
        this.searchResults = [];

        this.searchResults = this.faqs.filter((item) => {
            return item.Question.toLowerCase().includes(searchTerm);
        });

        if(this.searchResults.length == 0){
            this.searchResults = this.faqs;
        }
    }

    disconnectedCallback(){
        clearTimeout(this.timer);
        this.timer = null;
    }
}