using Amazon.Lambda.Core;
using Amazon.Lambda.RuntimeSupport;
using Amazon.Lambda.Serialization.SystemTextJson;
using System;
using System.Threading.Tasks;

namespace AWSLambda2
{
    public class MyFunction
    {
        /// <summary>
        /// The main entry point for the custom runtime.
        /// </summary>
        /// <param name="_args"></param>
        private static async Task Main(string[] _args)
        {
            Func<string, ILambdaContext, string> func = FunctionHandler;
            using (var handlerWrapper = HandlerWrapper.GetHandlerWrapper(func, new LambdaJsonSerializer()))
            using (var bootstrap = new LambdaBootstrap(handlerWrapper))
            {
                await bootstrap.RunAsync();
            }
        }

        /// <summary>
        /// A simple function that takes a string and does a ToUpper
        ///
        /// To use this handler to respond to an AWS event, reference the appropriate package from 
        /// https://github.com/aws/aws-lambda-dotnet#events
        /// and change the string input parameter to the desired event type.
        /// </summary>
        /// <param name="input"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static string FunctionHandler(string input, ILambdaContext context)
        {
            return input?.ToUpper();
        }
    }
}