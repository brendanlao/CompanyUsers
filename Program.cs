using System;
using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using CompanyUsers.Models;
using CompanyUsers.Data;

namespace CompanyUsers
{
    internal class Program
    {
        static void Main(string[] args)
        {      
            string usersJson = File.ReadAllText("Users.json");
            string userJobInfoJson = File.ReadAllText("UserJobInfo.json");
            string userSalaryJson = File.ReadAllText("UserSalary.json");
            IConfiguration config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();
            DataContextDapper d = new(config);

            IEnumerable<Users>? users = JsonConvert.DeserializeObject<IEnumerable<Users>>(usersJson);
            IEnumerable<UserJobInfo>? userJobInfo = JsonConvert.DeserializeObject<IEnumerable<UserJobInfo>>(userJobInfoJson);
            IEnumerable<UserSalary>? userSalaries = JsonConvert.DeserializeObject<IEnumerable<UserSalary>>(userSalaryJson);

            if (users != null)
            {
                foreach(Users u in users)
                {
                    string sql = @"INSERT INTO TutorialAppSchema.Users (
                                    UserId,
                                    FirstName,
                                    LastName,
                                    Email,
                                    Gender,
                                    Active
                                    ) VALUES ('" + u.UserId
                                    + "','" + u.FirstName
                                    + "','" + EscapeSingleQuote(u.LastName)
                                    + "','" + u.Email
                                    + "','" + u.Gender
                                    + "','" + u.Active
                                    + "')";

                    d.ExecuteSql(sql);
                }
            }

            if (userJobInfo != null)
            {
                foreach(UserJobInfo u in userJobInfo)
                {
                    string sql = @"INSERT INTO TutorialAppSchema.UserJobInfo (
                        UserId,
                        JobTitle,
                        Department
                        ) VALUES ('" + u.UserId
                        + "','" + u.JobTitle
                        + "','" + u.Department
                        + "')";

                    d.ExecuteSql(sql);
                }
            }
            
            if (userSalaries != null)
            {
                foreach(UserSalary u in userSalaries)
                {
                    string sql = @"INSERT INTO TutorialAppSchema.UserSalary (
                        UserId,
                        Salary
                        ) VALUES ('" + u.UserId
                        + "','" + u.Salary
                        + "')";
                    d.ExecuteSql(sql);
                }
            }
        }

        static string EscapeSingleQuote(string input)
        {
            string output = input.Replace("'", "''");
            return output;
        }
    }
}
