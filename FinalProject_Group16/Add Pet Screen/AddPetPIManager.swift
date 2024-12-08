//
//  AddPetPIManager.swift
//  FinalProject_Group16
//
//  Created by Zhiyu Li on 11/28/24.
//

import Foundation

extension AddPetViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
