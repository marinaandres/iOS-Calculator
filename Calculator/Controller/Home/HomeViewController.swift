//
//  HomeViewController.swift
//  Calculator
//
//  Created by Marina Andrés Aragón on 7/3/23.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //Labels
    @IBOutlet weak var resultLabel: UILabel!
    //Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    //Operadores
    @IBOutlet weak var operadorAC: UIButton!
    @IBOutlet weak var operadormasmenos: UIButton!
    @IBOutlet weak var operadorPorcentaje: UIButton!
    @IBOutlet weak var operadorDivision: UIButton!
    @IBOutlet weak var operadorMultiplicacion: UIButton!
    @IBOutlet weak var operadorSuma: UIButton!
    @IBOutlet weak var operadorIgual: UIButton!
    @IBOutlet weak var operadorResta: UIButton!
    //MARK: - Variables
    private var total:Double = 0 //Total de cada operación
    private var temp:Double = 0 //Valor en Pantalla
    private var operating = false //designa si se ha seleccionado un operador.
    private var decimal = false //Se convertira en true cuando se pulse el botón decimal
    private var operation: OperationType = .ninguno //Operación actual
    
    //MARK: - Constantes
    private let kDecimalSeparator = Locale.current.decimalSeparator
    private let kMaxLength = 9
    private let kTotal = "total"
    private enum OperationType {
        case ninguno,porcentaje,division,multiplicacion,resta,suma
    }
    
    //Formateo de valores auxiliar
    private let auxFormatter:NumberFormatter = { let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    //Formateo de valores auxiliar total
    private let auxTotalFormatter:NumberFormatter = { let formatter = NumberFormatter()
        
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    //Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        
        return formatter
    }()
    
    //Formateo de valores cientificos por pantalla por defecto
    private let printScientificFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // MARK: - Navigation
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        total = UserDefaults.standard.double(forKey: kTotal)
        result()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        operadorAC.round()
        operadormasmenos.round()
        operadorPorcentaje.round()
        operadorDivision.round()
        operadorMultiplicacion.round()
        operadorResta.round()
        operadorSuma.round()
        operadorIgual.round()
        numberDecimal.round()
    }
    
    //MARK: - Actions
    
    @IBAction func acAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    @IBAction func masMenosAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    @IBAction func porcentajeAction(_ sender: UIButton) {
        if operation != .porcentaje {
            result()
        }
        operating = true
        operation = .porcentaje
        result()
        sender.shine()
    }
    @IBAction func divisionAction(_ sender: UIButton) {
        if operation != .ninguno {
            result()
        }
        operating = true
        operation = .division
        sender.selectedOperation(true)
        sender.shine()
    }
    @IBAction func multiplicacionAction(_ sender: UIButton) {
        if operation != .ninguno {
            result()
        }
        operating = true
        operation = .multiplicacion
        sender.selectedOperation(true)
        sender.shine()
    }
    
    @IBAction func operadorRestaAction(_ sender: UIButton) {
        if operation != .ninguno {
            result()
        }
        operating = true
        operation = .resta
        sender.selectedOperation(true)
        sender.shine()
    }
    
    @IBAction func sumaAction(_ sender: UIButton) {
        if operation != .ninguno {
            result()
        }
        operating = true
        operation = .suma
        sender.selectedOperation(true)
        sender.shine()
    }
    
    @IBAction func operacionIgualAction(_ sender: UIButton) {
        result()
      
        sender.shine()
    }
    
    @IBAction func numeroDecimal(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))
        
        if !operating && currentTemp!.count >= kMaxLength {
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator!
    decimal = true
    selectedVisualOperation()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        operadorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))
        if !operating && currentTemp!.count >= kMaxLength {
            
        }
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))
        if operating {
            total = total == 0 ? temp : total
            currentTemp = ""
            resultLabel.text = ""
            operating = false
        }
        if decimal {
            currentTemp = String("\(currentTemp)\(kDecimalSeparator))")
            decimal = false
        }
        
        let number = sender.tag
        
        temp = Double(currentTemp! + String(number))!
        
       /* print("\(temp)")
        print("\(String(describing: currentTemp))")
        print("\(number)")*/
        
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        selectedVisualOperation()
        sender.shine()
        
    }
    
    private func clear(){
        operation = .ninguno
        operadorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        } else {
            total = 0
            result()
        }
        
    }
    private func result(){
        switch operation {
            
        case .ninguno:
            break
            //No hacemos nada
        case .porcentaje:
            total = temp / 100
            break
        case .division:
            total = total / temp
            break
        case .multiplicacion:
            total = total * temp
            break
        case .resta:
            total = total - temp
            break
        case .suma:
            total = total + temp
            break
        }
        
    // formateo en Pantalla
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        operation = .ninguno
        selectedVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
    }
    private func selectedVisualOperation() {
        if !operating  {
            operadorDivision.selectedOperation(false)
            operadorSuma.selectedOperation(false)
            operadorResta.selectedOperation(false)
            operadorMultiplicacion.selectedOperation(false)
         
        } else {
            switch operation {
            case .ninguno, .porcentaje:
                operadorDivision.selectedOperation(false)
                operadorSuma.selectedOperation(false)
                operadorResta.selectedOperation(false)
                operadorMultiplicacion.selectedOperation(false)
                break
            case .division:
                operadorDivision.selectedOperation(true)
                operadorSuma.selectedOperation(false)
                operadorResta.selectedOperation(false)
                operadorMultiplicacion.selectedOperation(false)
                break
            case .multiplicacion:
                operadorDivision.selectedOperation(false)
                operadorSuma.selectedOperation(false)
                operadorResta.selectedOperation(false)
                operadorMultiplicacion.selectedOperation(true)
                break
            case .resta:
                operadorDivision.selectedOperation(false)
                operadorSuma.selectedOperation(false)
                operadorResta.selectedOperation(true)
                operadorMultiplicacion.selectedOperation(false)
                break
            case .suma:
                operadorDivision.selectedOperation(false)
                operadorSuma.selectedOperation(true)
                operadorResta.selectedOperation(false)
                operadorMultiplicacion.selectedOperation(false)
                break
            }
            
            
            
        }
    }
}
