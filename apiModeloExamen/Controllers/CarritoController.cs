using apiModeloExamen.Repositories.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace apiModeloExamen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CarritoController : ControllerBase
    {
        private readonly ICarritoRepository _repo;

        public CarritoController(ICarritoRepository repo)
        {
            _repo = repo;
        }

        [HttpGet("obtener-activo/{idUsuario}")]
        public async Task<IActionResult> ObtenerCarritoActivo(int idUsuario)
        {
            var idCarrito = await _repo.ObtenerCarritoActivoAsync(idUsuario);
            return Ok(idCarrito);
        }

        [HttpPost("agregar-producto")]
        public async Task<IActionResult> AgregarProducto(int idCarrito, int idProducto, int cantidad)
        {
            await _repo.AgregarProductoAsync(idCarrito, idProducto, cantidad);
            return Ok();
        }

        [HttpGet("ver/{idCarrito}")]
        public async Task<IActionResult> VerCarrito(int idCarrito)
        {
            var detalles = await _repo.VerCarritoAsync(idCarrito);
            return Ok(detalles);
        }
    }
}
