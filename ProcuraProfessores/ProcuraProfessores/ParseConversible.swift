//
//  ParseConversible.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 08/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

import Parse

//Protocol that indicates that the object exists in Parse
protocol ParseConversible {
    init(with pFObject: PFObject)
}
