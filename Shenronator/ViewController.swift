	//
//  ViewController.swift
//  Shenronator
//
//  Created by Julien Catteau on 03/04/16.
//  Copyright © 2016 Julien Catteau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // PROPERTY
    private var _api : Api = Api();
    private var _listPerso : [Personnage]    = [];
    private var _listQuestion : [Question]   = [];
    private var _listReponse : [Reponse]     = [];
    private var _idQuestionCourante : String = "";
    private var _persoTrouve : Bool = false;
    
    // MARKS
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var TF_nomPersonnage: UITextField!
    @IBOutlet weak var BT_addPersonnage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground("porunga.jpg");
        getListPerso();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func buttonYes(sender: UIButton) {
        if _persoTrouve {
            //Play an other game
        }else
        {
            setReponseQuestion("1");
        }
    }
    
    @IBAction func buttonNo(sender: UIButton) {
        if _persoTrouve {
            BT_addPersonnage.hidden = false;
            TF_nomPersonnage.hidden = false;
        }else
        {
            setReponseQuestion("2");
        }
    }
    
    @IBAction func ajoutePerso(sender: UIButton) {
        addPersonnage("");
    }
    
    
    // MARK: Methods
    private func addPersonnage(nomPersonnage: String)
    {
        let jsonData = formatJsonToPostAddPersonnage(nomPersonnage);
        _api.postRequestOnApi(jsonData, url: "http://192.168.206.1:4242/Personnage/addPersonnage") { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                print("yes");
            }
            else {
                print("fuck");
            }
        }
    }
    
    private func formatJsonToPostAddPersonnage(nomPersonnage: String) -> String
    {
        var json : String = "{\"nomPersonnage\" : SANGOKU, listReponse : [";
        for reponse in _listReponse {
            json += reponse.toJsonString() + ",";
        }
        json = json.substringToIndex(json.endIndex.predecessor());
        json += "]}";
        
        return json;
    }
    
    //Effectue un appel au webservice avec la réponse de l'utilisateur et rempli la liste des persos restant
    private func setReponseQuestion(yesOrNot: String)
    {
        let idQuestion = _listQuestion.last?.id;
        _listReponse.append(Reponse(idQuestion: idQuestion!, choix:yesOrNot));
        let listIdPerso = stringifyIdInListPerso(_listPerso);
        var url = "http://192.168.206.1:4242/questions/setReponseQuestion/"+yesOrNot+"/"+idQuestion!;
        url += "/"+listIdPerso;
        _api.getRequestOnAPI(url, doSomethingWithJson: rempliListPersoFromJSON );
    }
    
    
    //Retourne la question à poser
    private func getQuestionAPoser()
    {
        let listIdPerso = stringifyIdInListPerso(_listPerso);
        let listIdQuestionDejaPose = stringifyIdInListQuestion(_listQuestion);
        let url = "http://192.168.206.1:4242/questions/getQuestionAPose/"+listIdQuestionDejaPose+"/"+listIdPerso;
        _api.getRequestOnAPI(url, doSomethingWithJson: parseJsonQuestion );
    }
    
    //Rempli la liste de personnageRestant
    private func getListPerso()
    {
        let url = "http://192.168.206.1:4242/personnages/getAllPersonnages";
        _api.getRequestOnAPI(url, doSomethingWithJson: rempliListPersoFromJSON );
    }
    
    //Retourne une chaine avec tous les Ids de personnages restant séparés par des virgules
    private func stringifyIdInListPerso(list: [Personnage]) -> String
    {
        var allId : String = "";
        for personnage in list {
            allId += personnage.id+",";
        }
        allId = allId.substringToIndex(allId.endIndex.predecessor());
        return allId;
    }
    
    //Retourne une chaine avec tous les Ids de questions déja posées séparés par des virgules
    private func stringifyIdInListQuestion(list: [Question]) -> String
    {
        var allId : String = "";
        for question in list {
            allId += question.id+",";
        }
        if allId != "" {
            allId = allId.substringToIndex(allId.endIndex.predecessor());
        }else
        {
            allId = "0";
        }
        return allId;
    }
    
    //Affiche le personnage si c'est le dernier dans la liste
    private func ifDernierPersoPrintName()-> Bool
    {
        var findOrNot = false;
        if self._listPerso.count == 1
        {
            affichePersoTrouve(self._listPerso[0].nom);
            _persoTrouve = true;
            findOrNot = true;
        }
        return findOrNot;
    }
    
    //Region : Affichage UI
    
    //Affiche le personnage trouvé
    private func affichePersoTrouve(name: String)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.labelQuestion.text = "Pensez-vous à : " + name;
        }
    }
    
    //Affiche la question à poser
    private func afficheQuestionAPoser(libelle: String)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.labelQuestion.text = libelle;
        }
    }
    
    //Region : Parser JSON && Connexion API
    
    //Parse le Json avec dans un objet question
    //+ Affiche la question à l'utilisateur
    private func parseJsonQuestion(json: NSDictionary)
    {
        if let questions = json["Question"] as? [[String: AnyObject]]
        {
            for question in questions
            {
                
                let q : Question = Question(JSONDictionary: question);
                self._listQuestion.append(q);
                self._idQuestionCourante = q.id;
                
                //On affiche la question
                afficheQuestionAPoser(q.libelle);
            }
        }

    }
    
    //Parse le json dans le tableau de personnages restant
    private func rempliListPersoFromJSON(json: NSDictionary)
    {
        self._listPerso = [];
        
        if let personnages = json["Personnages"] as? [[String: AnyObject]]
        {
            for personnage in personnages
            {
                let perso : Personnage = Personnage(JSONDictionary: personnage);
                self._listPerso.append(perso);
            }
        }
        
        //Si il reste qu'un perso dans la liste on affiche la réponse
        //Sinon on pose la prochaine question
        if !ifDernierPersoPrintName()
        {
            getQuestionAPoser();
        }
    }
}

