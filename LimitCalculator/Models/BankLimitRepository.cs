using BusinessObjects;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Configuration;

namespace Models {

    public class BankLimitRepository : IBankLimitRepository
    {

        private readonly IConfiguration _configuration;
        public BankLimitRepository(IConfiguration configuration) 
        {
            _configuration = configuration;
        }

        public IEnumerable<BankLimit> GetLimits()
         {


            var bankLimits = new List<BankLimit>();
            using (var conn = new SqlConnection(_configuration["ConnectionStrings:DefaultDB"]))
            {
                
            conn.Open();

            using (var comm = new SqlCommand("GetDailyBankLimits", conn))
                { 
                comm.CommandType = CommandType.StoredProcedure;
                    using (var dr = comm.ExecuteReader())
                    {

                        while (dr.Read())
                        {
                            BankLimit limitRow = new BankLimit();

                            limitRow.BankName = dr.GetString(dr.GetOrdinal("bank_name"));
                            limitRow.Rating =  dr.GetInt32(dr.GetOrdinal("rating"));
                            limitRow.TotalAssets = dr.GetInt64(dr.GetOrdinal("total_assets"));
                            limitRow.LimitAmt =  dr.GetInt64(dr.GetOrdinal("limit_amt"));
                            limitRow.LimitDate =  dr.GetDateTime(dr.GetOrdinal("limit_date"));

                            bankLimits.Add(limitRow);
                        }
                    }
                }
            }

            return bankLimits;
         }

    }

}