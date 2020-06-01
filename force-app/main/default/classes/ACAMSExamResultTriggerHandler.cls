public class ACAMSExamResultTriggerHandler extends CCAviTriggerHandler {

    private List<Exam_Results__c> newList;
    private List<Exam_Results__c> oldList;
    private Map<Id, Exam_Results__c> newMap;
    private Map<Id, Exam_Results__c> oldMap;
    public Set<Id> contactIds = new Set<Id>();
    public Set<Id> eadIds = new Set<Id>();
    public Set<Id> extnsnIds = new Set<Id>();
    Public boolean exec = false;
    Public boolean isPearsonVUE = false;
    Public string type;

    PearsonVueIntegration__c pv = PearsonVueIntegration__c.getOrgDefaults();

    public ACAMSExamResultTriggerHandler() {
        super();
        this.newList = (List<Exam_Results__c>) Trigger.new;
        this.oldList = (List<Exam_Results__c>) Trigger.old;
        this.newMap = (Map<Id, Exam_Results__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Exam_Results__c>) Trigger.oldMap;
    }

    public override void beforeInsert() {

        ExamResultHelper.UpdateCertResult(this.newList);
        ExamResultHelper.UpdateExamType(this.newList);
        ExamResultHelper.UpdatePVDates(this.newList);
    }

    public override void beforeUpdate() {
        ExamResultHelper.UpdateCertResult(this.newList);
        ExamResultHelper.UpdateExamType(this.newList);
        ExamResultHelper.UpdatePVDates(this.newList);
    }
    public override void afterInsert() {
        for (Exam_Results__c e : this.newList) {
            if (e.PearsonVUE__c != true) {
                ExamResultHelper.UpsertExamResultOnAsset(this.newList);
            }
        }
        for (Exam_Results__c e : this.newList) {
            if (e.PearsonVUE__c == true) {
                isPearsonVUE = true;
            }
            if (e.Extension__c == true) {
                type = 'extension';
            } else if (e.Retake__c == true) {
                type = 'retake';
            } else if (e.Original_EAD__c == true) {
                type = 'original';
            }
            if (e.Original_EAD__c == true) {
                contactIds.add(e.Account__c);
                eadIds.add(e.id);

                exec = true;
            } else if (e.Original_EAD__c == false) {

                eadIds.add(e.id);
            }
        }
        if (isPearsonVUE) {
            if (exec == true) {
                if (!ExamResultHelper.isVUERecursiveCheck)
                    ExamResultHelper.SendContactInfo(contactIds);
                if (!ExamResultHelper.isVUERecursiveEADCheck)
                    ExamResultHelper.SendEADInfo(eadIds, pv.AddTransaction__c, type);
            } else {
                if (!ExamResultHelper.isVUERecursiveEADCheck)
                    ExamResultHelper.SendEADInfo(eadIds, pv.AddTransaction__c, type);

            }
        }
    }

    public override void afterUpdate() {
        for (Exam_Results__c e : this.newList) {
            if (e.PearsonVUE__c != true) {
                ExamResultHelper.UpsertExamResultOnAsset(this.newList);
            }
        }
        for (Exam_Results__c e : this.newList) {
            for (Exam_Results__c o : this.oldList) {
                if (e.Extension__c == true) {
                    type = 'extension';
                } else if (e.Retake__c == true) {
                    type = 'retake';
                }

                if (e.PearsonVUE__c == true && ((o.Extension__c != e.Extension__c && e.Extension__c == true) || o.eligibilityApptDateFirst__c != e.eligibilityApptDateFirst__c || o.eligibilityApptDateLast__c != e.eligibilityApptDateLast__c || o.examSeriesCode__c != e.examSeriesCode__c)) {
                    extnsnIds.add(e.id);
                }
            }
        }
        if (!ExamResultHelper.isVUERecursiveEADCheck) {
            ExamResultHelper.SendEADInfo(extnsnIds, pv.UpdateTransaction__c, type);
        }
    }
}