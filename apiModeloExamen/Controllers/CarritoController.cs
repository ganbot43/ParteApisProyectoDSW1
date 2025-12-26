using apiModeloExamen.Repositories.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

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
            try
            {
                var idCarrito = await _repo.ObtenerCarritoActivoAsync(idUsuario);
                return Ok(idCarrito);
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Error: {ex.Message}");
                return StatusCode(500, ex.Message); // Devuelve el mensaje al frontend
            }
        }

        [HttpPost("agregar-producto")]
        public async Task<IActionResult> AgregarProducto(int idCarrito, int idProducto, int cantidad)
        {
            try
            {
                await _repo.AgregarProductoAsync(idCarrito, idProducto, cantidad);
                return Ok();
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"[SQL ERROR] {ex.Message}");
                // Opcional: puedes devolver el mensaje al frontend para depuración
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("ver/{idCarrito}")]
        public async Task<IActionResult> VerCarrito(int idCarrito)
        {
            try
            {
                var detalles = await _repo.VerCarritoAsync(idCarrito);
                return Ok(detalles);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al ver carrito: {ex.Message}");
            }
        }

        [HttpPost("eliminar-producto")]
        public async Task<IActionResult> EliminarProducto(int idCarrito, int idProducto)
        {
            await _repo.EliminarProductoAsync(idCarrito, idProducto);
            return Ok();
        }
    }
}
