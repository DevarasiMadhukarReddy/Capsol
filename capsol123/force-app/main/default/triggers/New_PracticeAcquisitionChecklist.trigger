trigger New_PracticeAcquisitionChecklist on Practice_Acquisition_Checklist__c (After insert, After update, Before insert, Before update) {
New_PracticeAcquisitionChecklistHandler PracticeAqua = new New_PracticeAcquisitionChecklistHandler();
    if(Trigger.isBefore){
        PracticeAqua.populatecontactrole(trigger.new);
}
}