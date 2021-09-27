//
//  TableViewController.swift
//  again
//


import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,CardDetailTableViewCellDelegate{
    func CardDetailTableViewCell(cell: CardDetailTableViewCell, didTappedThe button: UIButton?) {
        guard  let indexPath = tableview.indexPath(for: cell)
        else
        {
            return
        }
       
        db.DeleteRowDatabase(CardNumber: cards[indexPath.row].CardNumber)
        cards = db.read()
        tableview.reloadData()
        if cards.count == 0
        {
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                   let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                                   self.navigationController?.navigationBar.isHidden = true
                                   self.navigationController?.pushViewController(vc,
                                                                                 animated: true)
            
        }
    }
    

    
    var db:DBHelper = DBHelper()
    
    var cards:[CardDetail] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CardDetailTableViewCell", for: indexPath) as! CardDetailTableViewCell
        cell.celldelegate = self
        cell.selectionStyle = .none
        let last4 = "**** **** **** \(String(cards[indexPath.row].CardNumber.suffix(4)))"
        cell.lblcardnumber.text = last4
        cell.lblcardname.text = cards[indexPath.row].CardName
        cell.lblcardexp.text = "Expires \(cards[indexPath.row].CardExp)"
                                               
        return cell
    }

    
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cards = db.read()
        tableview.register(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CardDetailTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnback(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                           self.navigationController?.navigationBar.isHidden = true
                           self.navigationController?.pushViewController(vc,
                                                                         animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
