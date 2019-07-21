using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace dotnetcoreapi.Controllers
{
    [Route("api/[controller]")]
    public class ConfigurationController : Controller
    {
        private readonly IConfiguration _configurationRoot;
        private readonly ILogger _logger;

        public ConfigurationController(IConfiguration configuration, ILogger<ConfigurationController> logger)
        {
            _configurationRoot = configuration;
            _logger = logger;
        }

        [HttpGet("{key}")]
        public IActionResult GetValueForKey(string key)
        {
            //_logger.LogInformation("getting key '{0}'", key);
            Console.WriteLine("from stdout: getting key '{0}'", key);
            return Json(_configurationRoot[key]);
        }
    }
}
