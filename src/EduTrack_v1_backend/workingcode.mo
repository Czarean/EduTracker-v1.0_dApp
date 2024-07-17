//This is a working code! 
//Do not replace until main.mo has been confirmed working

import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Mytypes "edutracktypes";
import Result "mo:base/Result";
import Principal "mo:base/Principal";


actor EduTrack{

//Creacion de Hashmaps:-------------------------------------------------------------------------------------------------------------------------

    let Estudiantes = HashMap.HashMap<Text, Mytypes.Student>(10, Text.equal, Text.hash);
    let Professors = HashMap.HashMap<Text, Mytypes.Professor>(10, Text.equal, Text.hash);

//Funciones para Agregar Nuevos Profesores y Estudiantes :----------------------------------------------------------------------------------------

    //Estudiantes:
    public func addStudent(id: Text, name: Text, dob: Text, parentsName: Text, tutorName: Text, contactNumber: Text, email: Text): async Text {
        let student: Mytypes.Student = {
            name = name;
            dob = dob;
            parentsName = parentsName;
            tutorName = tutorName;
            contactNumber = contactNumber;
            email = email;
            progressTracker = Mytypes.initYears();
        };         
        Estudiantes.put(id, student);
        return "El Estudiante "  # name # " ha sido Ingresado a la base escolar de datos exitosamente" 

    };

    //Professors:
    public func addProfessor(id: Text, name: Text, email: Text, contactNumber: Text, principalId: Text, startingDate: Text, registrationDate: Text): async Result.Result<Text, Text> {
      if (not Text.equal(id, "") and not Text.equal(name, "") and not Text.equal(email, "") and not Text.equal(contactNumber, "") and not Text.equal(principalId, "") and not Text.equal(startingDate, "") and not Text.equal(registrationDate, "")) {
        
        let professor: Mytypes.Professor = {
          name = name;
          email = email;
          contactNumber = contactNumber ;
          principalId = principalId;
          startingDate = startingDate;
          registrationDate = registrationDate;

        };
          Professors.put(id, professor);
          return #ok("El Professor "  # name # " ha sido Ingresado a la base de datos Escolar exitosamente!");       
      } else {
          return #err("Please, fill in all the blanks before clicking submit! Thanks.");
        };
    };

//Funciones para regresar la info de los Profesores y Estudiantes:---------------------------------------------------------------------------------

    public func getStudent(id: Text): async ?Mytypes.Student {
        return Estudiantes.get(id);
    };

    public func getProfessor(id: Text): async ?Mytypes.Professor {
        return Professors.get(id);
    };

//Funciones para eliminar Profesores y Estudiantes:------------------------------------------------------------------------------------------------

    public shared func deleteStudent(delete: Text) : async Text {
        let result = await getStudent(delete); // getProfessor(delete) is an async message, so "await" is used to pause the execution of deleteProfessor until the promise returned by getProfessor(delete) is resolved.
        switch (result) {
            case (null) {
                return "Estudiante no encontrado"
            };
            case (?estudiante) {
                Estudiantes.delete(delete);
                return ("El Estudiante "  # estudiante.name # " ha sido Eliminado de la base de datos escolar exitosamente")
            }
        }
  };


    public func deleteProfessor(delete: Text) : async Text {
        let result = await getProfessor(delete); // getProfessor(delete) is an async message, so "await" is used to pause the execution of deleteProfessor until the promise returned by getProfessor(delete) is resolved.
        switch (result) {
            case (null) {
                return "Professor not Found " 
            };
            case (?professor) {
                Professors.delete(delete);
                return ("El Professor "  # professor.name # " ha sido Eliminado de la base de datos escolar exitosamente")
                }
            }
    };

//Functions to Update (V) Values on already created (K) Students inside a hashmap--------------------------------------------------------------

    //*Restricted Function*
    public shared(msg) func updateStudentEmail(studentId: Text, newEmail: Text) : async Text {
        let callerPrincipal = Principal.toText(msg.caller); 
        switch (adminacl.get(callerPrincipal)) {
            case (?principalSet) {
                switch (Estudiantes.get(studentId)) {
                    case (?student) {
                        let updatedStudent = { student with email = newEmail };
                        Estudiantes.put(studentId, updatedStudent);
                        return    studentId # " Email, has been successfully updated."
                    };
                    case (null) {
                        return "The Student "  # studentId # " does not exist on the school database"
                    }
                }
            };
            case (null) { 
              return "You are not authorized to update the students email";
            }
        }
    };
    
    public func updateStudentDob(studentId: Text, newDob: Text) : async Text {
        switch (Estudiantes.get(studentId)) {
            case (?student) {
                let updatedStudent = { student with dob = newDob };
                Estudiantes.put(studentId, updatedStudent);
                return    studentId # " Date of Birth, has been successfully updated."
            };
            case (null) {
              return "The Student "  # studentId # " does not exist on the school database"
            };
        }
    };

    public func updateStudentParent(studentId: Text, newParent: Text) : async Text {
        switch (Estudiantes.get(studentId)) {
            case (?student) {
                let updatedStudent = { student with parentsName = newParent };
                Estudiantes.put(studentId, updatedStudent);
                return    studentId # " Parent name, has been successfully updated."
            };
            case (null) {
              return "The Student "  # studentId # " does not exist on the school database"
            };
        }
    };

    public func updateStudentTutor(studentId: Text, newTutor: Text) : async Text {
        switch (Estudiantes.get(studentId)) {
            case (?student) {
                let updatedStudent = { student with tutorName = newTutor };
                Estudiantes.put(studentId, updatedStudent);
                return    studentId # " Tutor name, has been successfully updated."
            };
            case (null) {
              return "The Student "  # studentId # " does not exist on the school database"
            };
        }
    };

    public func updateStudentContactN(studentId: Text, newContactN: Text) : async Text {
        switch (Estudiantes.get(studentId)) {
            case (?student) {
                let updatedStudent = { student with contactNumber = newContactN };
                Estudiantes.put(studentId, updatedStudent);
                return    studentId # " contact number, has been successfully updated."
            };
            case (null) {
              return "The Student "  # studentId # " does not exist on the school database"
            };
        }
    };

//Functions to Update (V) Values on already created (K) Professors inside a hashmap--------------------------------------------------------------
    public func updateProfessorEmail(professorId: Text, newEmail: Text) : async Text {
        switch (Professors.get(professorId)) {
            case (?professors) { //IDK why but has to be all lower caps for it to work
                let updatedProfessor = { professors with email = newEmail }; //We use the same case progessors lowecase here as well.
                Professors.put(professorId, updatedProfessor);
                return    professorId # " Email, has been successfully updated."
            };
            case (null) {
              return "The Professor "  # professorId # " does not exist on the school database"
            };
        }
    };

    public func updateProfessorContactN(professorId: Text, newContactN: Text) : async Text {
        switch (Professors.get(professorId)) {
            case (?professors) { //IDK why but has to be all lower caps for it to work
                let updatedProfessor = { professors with contactNumber = newContactN }; //We use the same case progessors lowecase here as well.
                Professors.put(professorId, updatedProfessor);
                return    professorId # " contact number, has been successfully updated."
            };
            case (null) {
              return "The Professor "  # professorId # " does not exist on the school database"
            };
        }
    };

    public func updateProfessorPid(professorId: Text, newPid: Text) : async Text {
        switch (Professors.get(professorId)) {
            case (?professors) { //IDK why but has to be all lower caps for it to work
                let updatedProfessor = { professors with principalId = newPid }; //We use the same case progessors lowecase here as well.
                Professors.put(professorId, updatedProfessor);
                return    professorId # " Principal Id, has been successfully updated."
            };
            case (null) {
              return "The Professor "  # professorId # " does not exist on the school database"
            };
        }
    };

    public func updateProfessorStartingDate(professorId: Text, newStartingDate: Text) : async Text {
        switch (Professors.get(professorId)) {
            case (?professors) { //IDK why but has to be all lower caps for it to work
                let updatedProfessor = { professors with startingDate = newStartingDate }; //We use the same case progessors lowecase here as well.
                Professors.put(professorId, updatedProfessor);
                return    professorId # " Starting Date, has been successfully updated."
            };
            case (null) {
              return "The Professor "  # professorId # " does not exist on the school database"
            };
        }
    };

    public func updateProfessorRegistrationDate(professorId: Text, newRegistrationDate: Text) : async Text {
        switch (Professors.get(professorId)) {
            case (?professors) { //IDK why but has to be all lower caps for it to work
                let updatedProfessor = { professors with registrationDate = newRegistrationDate }; //We use the same case progessors lowecase here as well.
                Professors.put(professorId, updatedProfessor);
                return    professorId # " Email, has been successfully updated."
            };
            case (null) {
              return "The Professor "  # professorId # " does not exist on the school database"
            };
        }
    };


//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------ACESSS LIST FUNCTIONS-----------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------

    // Access List Hashmap Type
    type AdminPrincipalSet = Text;
    type ProfessorPrincipalSet = Text;

    // Initialize the admin, professor and user ACL   
    let adminacl = HashMap.HashMap<Text, AdminPrincipalSet>(2, Text.equal, Text.hash); 
    let professoracl = HashMap.HashMap<Text, ProfessorPrincipalSet>(2, Text.equal, Text.hash);

    //The ACL hashmap (acl) is initialized with an anonymous principal (anonymousPid).
    //Note: remove the below two lines of code below before you deploy to production as they are only for testing on the replica test enviroment.
    let anonymousPid: AdminPrincipalSet = "2vxsx-fae";
        adminacl.put("2vxsx-fae" , anonymousPid);

    //Replace the Principal, if you want to hardcode a Principal to be automatically added onto the ACL Hashmap. 
    //Fallback: As a security and Anti-lock mechanism, you should whitelist the deployer canister PID as shown in lines below
    //Doing this will allow your deployer canister to call all the functions so you can add/delete PIDs from the access list.
    //To get your deployer canister ID, use the dfx command: $dfx identity get-principal
    //And replace it on the below two lines of code: Once you do this, you do not have to worry if all Principals on the Access List stop having access because they forgot their credentials or whatever, you can just simply direct your Admins to create new Internet Identities, and then you can add the new Principal IDs to the Access list via the DFX Command: $dfx canister call canister_name addPrincipal '( "exampleId", "examplePrincipal" )'
    let canisterIdPid: AdminPrincipalSet = "xmrjp-ypfwv-gzymg-q35zv-tphew-xq6l7-k6kp3-nprrw-pmd4q-6vk2s-oqe";
        adminacl.put("xmrjp-ypfwv-gzymg-q35zv-tphew-xq6l7-k6kp3-nprrw-pmd4q-6vk2s-oqe" , canisterIdPid);

    //whoAmI Function: This returns the caller's Principal which can be useful for debugging or identification.
    public query msg func checkMyPrincipalId() : async Principal {
        return msg.caller;
    };

//---------------------------------------Add/Delete Admins Principals Functions ------------------------------------------------------------------------
  // *Restricted Function* to add Principals to the acl.HashMap. (When called, the function checks the caller against the "acl.HashMap" for authorization)
  // To make the calls from the deployer canister use the dfx command: $dfx canister call canister_name addPrincipal '( "exampleId", "examplePrincipal" )'
  public shared(msg) func addAdminPrincipal(id: Text, newPrincipal: Text): async Text { // Sintax: https://internetcomputer.org/docs/current/motoko/main/writing-motoko/caller-id#:~:text=public%20shared(msg)%20func%20inc()%20%3A%20async%20()%20%7B Adding Access Control https://internetcomputer.org/docs/current/motoko/main/writing-motoko/caller-id
    let callerPrincipal = Principal.toText(msg.caller); // Get the caller's principal as text // FYI: on update Functions the caller sintax is different: public shared(msg) func myFunction(i: Text, n: Text): async(){ 
    switch (adminacl.get(callerPrincipal)) { // Check if the caller is in the ACL
      case (?principalSet) { // If the caller is authorized, add the new principal to the ACL
        adminacl.put(id, newPrincipal);
        return "The Principal ID: " # newPrincipal # " has been successfully added to the Admins Access List";
      };
      case (null) { 
        return "You are not authorized to add principals to the Admins Access List";
      }
    }
  };

  //*Restricted Function* that deletes principals from the Access list Hashmap.
  public shared(msg) func deleteAdminPrincipal(delete: Text) : async Text {
    let callerPrincipal = Principal.toText(msg.caller); 
    switch (adminacl.get(callerPrincipal)) {
      case (?principalSet) {
        adminacl.delete(delete);
        return "Principal ID "  # delete # " has been deleted from the Admins Access list"
      };
      case (null) { 
          return "You are not authorized to delete principals from the Admins Access List";
      }
    }
  };

//---------------------------------------Add/Delete Professors Principals Functions ------------------------------------------------------------------------
  // *Restricted Function* to add Principals to the acl.HashMap. (When called, the function checks the caller against the "acl.HashMap" for authorization)
  // To make the calls from the deployer canister use the dfx command: $dfx canister call canister_name addPrincipal '( "exampleId", "examplePrincipal" )'
  public shared(msg) func addProfessorPrincipal(id: Text, newPrincipal: Text): async Text { // Sintax: https://internetcomputer.org/docs/current/motoko/main/writing-motoko/caller-id#:~:text=public%20shared(msg)%20func%20inc()%20%3A%20async%20()%20%7B Adding Access Control https://internetcomputer.org/docs/current/motoko/main/writing-motoko/caller-id
    let callerPrincipal = Principal.toText(msg.caller); // Get the caller's principal as text // FYI: on update Functions the caller sintax is different: public shared(msg) func myFunction(i: Text, n: Text): async(){ 
    switch (professoracl.get(callerPrincipal)) { // Check if the caller is in the ACL
      case (?principalSet) { // If the caller is authorized, add the new principal to the ACL
        professoracl.put(id, newPrincipal);
        return "The Admins Principal ID: " # newPrincipal # " has been successfully added to the Professors Access List";
      };
      case (null) { 
        return "You are not authorized to add principals to the Professors Access List";
      }
    }
  };

  //*Restricted Function* that deletes principals from the Access list Hashmap.
  public shared(msg) func deleteProfessorPrincipal(delete: Text) : async Text {
    let callerPrincipal = Principal.toText(msg.caller); 
    switch (professoracl.get(callerPrincipal)) {
      case (?principalSet) {
        professoracl.delete(delete);
        return "The Principal ID "  # delete # " has been deleted from the Professors Access list"
      };
      case (null) { 
          return "You are not authorized to delete principals from the Professors Access List";
      }
    }
  };
}

