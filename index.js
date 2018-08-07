var exec = require('child_process').exec


function privateRegisterAppFunction(username, password, company_name, app_name) {
    exec(`ruby node_modules/test-ruby/main.rb ${username} ${password} ${company_name} ${app_name}`,
    function (error, stdout, stderr) {
      if (error !== null) {
        console.log(error);
      } else {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      }
  });
}


class AutoGenSpaceship {
  constructor(username, password, company_name, app_name) {
    privateRegisterAppFunction(username, password, company_name, app_name);
  }
  
}


module.exports = AutoGenSpaceship;