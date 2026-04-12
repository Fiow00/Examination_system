-- =========================
-- Department Tests
-- =========================

   
CALL  public.InsertDepartment('Finance', 'Cairo');

   
CALL  public.InsertDepartment('', 'Cairo');

 
CALL  public.InsertDepartment('Finance', 'Alex');

  
CALL  public.UpdateDepartment(1, 'Finance Updated', 'Giza');

  
CALL  public.UpdateDepartment(999, 'Test', 'Test');

  
CALL  public.UpdateDepartment(2, 'Finance Updated', 'Alex');

     
CALL  public.DeleteDepartment(1);

  
CALL  public.DeleteDepartment(1);