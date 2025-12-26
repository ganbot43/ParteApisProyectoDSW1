using apiModeloExamen.Contracts.Dtos;
using apiModeloExamen.Repositories.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace apiModeloExamen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrdenController : ControllerBase
    {
        private readonly IOrdenRepository _repo;

        public OrdenController(IOrdenRepository repo)
        {
            _repo = repo;
        }

        [HttpPost("generar")]
        public async Task<IActionResult> GenerarOrden(int idUsuario)
        {
            await _repo.GenerarOrdenAsync(idUsuario);
            return Ok();
        }

        [HttpGet("por-usuario/{idUsuario}")]
        public async Task<IActionResult> ListarPorUsuario(int idUsuario)
        {
            var ordenes = await _repo.ListarPorUsuarioAsync(idUsuario);
            return Ok(ordenes);
        }

        // GET: api/Orden/detalle/{idOrden}
        [HttpGet("detalle/{idOrden}")]
        public async Task<ActionResult<List<PagoDetalladoDto>>> GetDetalleOrden(int idOrden)
        {
            var detalle = await _repo.ObtenerDetalleOrdenAsync(idOrden);
            if (detalle == null || !detalle.Any())
                return NotFound($"No se encontró detalle para la orden {idOrden}.");

            return Ok(detalle);
        }
    }
}