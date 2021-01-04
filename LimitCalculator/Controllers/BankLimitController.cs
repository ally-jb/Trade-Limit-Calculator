using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using BusinessObjects;
using Models;

namespace LimitCalculator.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BankLimitController : ControllerBase
    {

        private readonly IBankLimitRepository _repository;

        public BankLimitController(IBankLimitRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        public IEnumerable<BankLimit> Get()
        {
            return _repository.GetLimits(); 
        }
    }
}
